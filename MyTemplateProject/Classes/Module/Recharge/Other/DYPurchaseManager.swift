//
//  DYPurchaseManager.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/9/16.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit
import StoreKit
/**
 苹果内购管理类
 */


enum DYPurchasePayState: Int {
    
    ///付款成功后后台验证成功
    case chargeSuccessed = 0


    ///第一步请求失败
    case requestFaild = -10001
    ///第一步请求商品信息完成
    case requestFinished = -10002
    ///内购正在购买
    case purchasing = -10003
    ///内购付款成功
    case purchased = -10004
    ///内购重复购买
    case purchaseResubmit = -10005
    ///内购支付失败
    case purchaseFailed = -10006
    ///付款成功后后台验证失败
    case chargeFaild = -10008
    ///未找到相应商品
    case unfoundProductor = -10009
}

public let dy_Notification_purchase_chargeSuccessed = "dy_Notification_purchase_chargeSuccessed";

class DYPurchaseManager: NSObject {

    
    typealias RequestCompleted = (_ response: [String : Any]?, _ error: Error?) -> Void
    
    
    var requestCallback: RequestCompleted?
    
    
    private var requestState: DYPurchasePayState?
    
    private override init() {
        
        super.init()
    }
    
    static let shared = DYPurchaseManager.init();
    
    class func startRequest(_ productIdentifier: String, compeleted: @escaping RequestCompleted) {
        
        let manager = DYPurchaseManager.shared;
        manager.requestCallback = compeleted;
        SKPaymentQueue.default().add(manager);

        let request = SKProductsRequest.init(productIdentifiers: [productIdentifier]);
        request.delegate = manager;
        request.start();
        
    }
    
}


extension DYPurchaseManager: SKPaymentTransactionObserver, SKProductsRequestDelegate {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        
        for item in transactions {
            
            switch item.transactionState {
           
            case SKPaymentTransactionState.purchasing:
                print("DYPurchasePayState ------- 商品添加到列表")
                self.requestState = .purchasing;
                break;
            case SKPaymentTransactionState.purchased:
                print("DYPurchasePayState ------ 充值成功！")
                self.requestState = .purchased;
                self.completedPayTransaction(item);
                break;
            case SKPaymentTransactionState.restored:
                print("DYPurchasePayState ------ 重复交易！")
                self.requestState = .purchaseResubmit;
                let err = NSError.init(domain: "重复提交！", code: self.requestState?.rawValue ?? -1, userInfo: nil);
                self.requestCallback?(nil,err);
                SKPaymentQueue.default().finishTransaction(item);
                break;
            case SKPaymentTransactionState.failed:
                print("DYPurchasePayState ------ 充值失败")
                self.requestState = .purchaseFailed;
                let err = NSError.init(domain: "充值失败！", code: self.requestState?.rawValue ?? -1, userInfo: nil);
                self.requestCallback?(nil,err);
                SKPaymentQueue.default().finishTransaction(item);
                break;
            default:
                break;
            }
            
        }
        
    }
   
    
    /**
     .交易结束,当交易结束后还要去appstore上验证支付信息是否都正确,只有所有都正确后,我们就可以给用户我们的虚拟物品了。

     */
    private func completedPayTransaction(_ transaction: SKPaymentTransaction) {
        
        // 验证凭据，获取到苹果返回的交易凭据
        // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
        if let receiptURL = Bundle.main.appStoreReceiptURL {
            // 从沙盒中获取到购买凭据
            let receiptData = try? Data.init(contentsOf: receiptURL);
            
            /**
             BASE64 常用的编码方案，通常用于数据传输，以及加密算法的基础算法，传输过程中能够保证数据传输的稳定性
             BASE64是可以编码和解码的
             */
            if let encodeStr = receiptData?.base64EncodedString(options: .endLineWithLineFeed) {
                
                self.verifyInvoiceInfo(dataStr: encodeStr, transaction: transaction);
            }
                       
        }
        
    }
    
   
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        if let product = response.products.first {
            
            let payment = SKPayment.init(product: product);
            
            SKPaymentQueue.default().add(payment);
        } else {
            
            self.requestState = .unfoundProductor;
            let err = NSError.init(domain: "没有找到对应的支付商品！", code: self.requestState?.rawValue ?? -1, userInfo: nil);
            self.requestCallback?(nil,err);
        }
        
        
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
           
        self.requestState = .requestFaild;
        let err = NSError.init(domain: "请求支付失败！", code: self.requestState?.rawValue ?? -1, userInfo: nil);
        self.requestCallback?(nil,err);
        print("DYPurchasePayState -------- 请求失败！")
        print(error);
      
    }
       
    func requestDidFinish(_ request: SKRequest) {
        print("DYPurchasePayState -------- 请求信息完成");
        self.requestState = .requestFinished;
    }
    
    
    
    
    func verifyInvoiceInfo(dataStr: String, transaction: SKPaymentTransaction) {
        
        
        ChargeNetwork.verifyPurchase(receiptData: dataStr).dy_startRequest { (response, error) in
            if let result = response as? [String : Any] {
               
                print("请求成功：%@",response);
                self.requestState = .chargeSuccessed;
                SKPaymentQueue.default().remove(self);
                self.requestCallback?(result,nil);
                if self.requestCallback == nil {
                    //本地票据验证成功就发通知到外面 充值成功
                    NotificationCenter.default.post(name: .init(dy_Notification_purchase_chargeSuccessed), object: response);
                }
                SKPaymentQueue.default().finishTransaction(transaction);
                
            } else {
                
                print("内购票据验证失败： %@", response);
                self.requestState = .chargeFaild;
                let err = NSError.init(domain: error?.errorMessage ?? "充值失败！", code: self.requestState?.rawValue ?? -1, userInfo: nil);
                self.requestCallback?(nil,err);
            }
        }
      
        
    }
    
    
    
    
    private func testVeriyMyself(dataStr: String) {
        
        // 存储收据环境的变量
        let environment = "environment=Sandbox";
        
        var StoreURL: URL?
        if (environment == "environment=Sandbox") {
            StoreURL = URL.init(string: "https://sandbox.itunes.apple.com")
        }
        else {
            StoreURL = URL.init(string:"https://buy.itunes.apple.com");
        }
        
        let httpRequest = DYBaseNetwork.init();
        httpRequest.dy_requestMethod = .POST;
        httpRequest.dy_requestTimeout = 50;
        httpRequest.dy_requestArgument = [
            "receipt-data" : dataStr
        ];
        httpRequest.dy_baseURL = StoreURL?.absoluteString ?? "";
        httpRequest.dy_requestUrl = "/verifyReceipt";
        httpRequest.dy_requestSerializerType = .JSON;
        httpRequest.dy_responseSerializerType = .JSON;
        httpRequest.startWithCompletionBlock(success: { (request) in
            
            
            if let response = request.responseJSONObject as? [String : Any] {
                
                
                //这里可以等待上面请求的数据完成后并且state = 0 验证凭据成功来判断后进入自己服务器逻辑的判断,也可以直接进行服务器逻辑的判断,验证凭据也就是一个安全的问题。楼主这里没有用state = 0 来判断。
                //  [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                /*
                 /**
                 * 服务器二次验证代码
                 * 21000 App Store不能读取你提供的JSON对象
                 * 21002 receipt-data域的数据有问题
                 * 21003 receipt无法通过验证
                 * 21004 提供的shared secret不匹配你账号中的shared secret
                 * 21005 receipt服务器当前不可用
                 * 21006 receipt合法，但是订阅已过期。服务器接收到这个状态码时，receipt数据仍然会解码并一起发送
                 * 21007 receipt是Sandbox receipt，但却发送至生产系统的验证服务
                 * 21008 receipt是生产receipt，但却发送至Sandbox环境的验证服务
                 */
                 */
                if let status = response["status"] as? Int, status == 0 {
                    
                    
                    
                } else {
                    
                    print("内购票据验证失败： %@", response);
                    self.requestState = .chargeFaild;
                    let err = NSError.init(domain: "充值失败！", code: self.requestState?.rawValue ?? -1, userInfo: nil);
                    self.requestCallback?(nil,err);
                }
                
                
            }
            
        }) { (request) in
            self.requestState = .chargeFaild;
            let err = NSError.init(domain: "充值失败！", code: self.requestState?.rawValue ?? -1, userInfo: nil);
            self.requestCallback?(nil,err);
            print("验证购买过程中发生错误，错误信息：%@",request.error);
        }
        
    }
}
