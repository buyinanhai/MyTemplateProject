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

typealias RequestCompleted = (_ response: [String : Any]?, _ error: Error?) -> Void
class DYPurchaseManager: NSObject, SKProductsRequestDelegate {
    
    var transactionIdentifier : String?
    var requestCallback: RequestCompleted?
    
    private var requestState: DYPurchasePayState?
    
    
    static let shared = DYPurchaseManager.init();
    
    private var timeoutInterval = 60;
    
    private override init() {
        
        super.init()
    }
    
    static func addPaymentObserwer() {
        
        DispatchQueue.yd_once {
            print("addPaymentObserwer-----------")
            SKPaymentQueue.default().add(DYPurchaseManager.shared);
        }
        
    }
   
    
    class func startRequest(_ productIdentifier: String, compeleted: @escaping RequestCompleted) {
        
        DYPurchaseManager.shared.requestCallback = compeleted;
        
        let request = SKProductsRequest.init(productIdentifiers: [productIdentifier]);
        request.delegate = DYPurchaseManager.shared;
        request.start();
        
        
    }
    
    
    @objc
    private func timerFire() {
        
        self.timeoutInterval -= 1;
        if self.timeoutInterval < 0 {
            
            let error = NSError.init(domain: "请求超时， 请稍后重试", code: -888, userInfo: nil);
            self.requestCallback?(nil, error);
            self.timer?.invalidate();
            self.timeoutInterval = 60;
        }
        
    }
//    /**
//     删除相同的监听
//     */
//    fileprivate class func removeSameItem(_ handler: DYPurchaseHandler) -> Bool {
//
//        var shouldBeMove = false;
//        for (index,item)  in DYPurchaseManager.shared.items.enumerated() {
//
//            if let identifier1 = item.transactionIdentifier, let identifier2 = handler.transactionIdentifier {
//                if identifier1 == identifier2, item != handler {
//                    DYPurchaseManager.shared.items.remove(at: index);
//                    SKPaymentQueue.default().remove(item);
//                    shouldBeMove = true;
//                    break;
//                }
//            }
//        }
//        return shouldBeMove;
//    }
//
//    /**
//     丢弃handler
//     */
//    fileprivate class func discardItem(_ handler: DYPurchaseHandler) {
//
//        for (index,item)  in DYPurchaseManager.shared.items.enumerated() {
//            if  item == handler {
//                DYPurchaseManager.shared.items.remove(at: index);
//                SKPaymentQueue.default().remove(item);
//                break;
//            }
//        }
//
//    }
//
//    private var items: [DYPurchaseHandler] = [];
    private var localTransactions: [String :SKPaymentTransaction] = [:];
    private var timer: Timer?
    
}
extension DYPurchaseManager: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    
        for item in transactions {
            if item.transactionState == .purchased {
                if let identifier = item.transactionIdentifier {
                    
                    self.localTransactions[identifier] = item;
                }
            }
        }
        //只取最后一个
        if let currentTransaction = transactions.last {
            switch currentTransaction.transactionState {
            
            case SKPaymentTransactionState.purchasing:
                print("DYPurchasePayState ------- 商品添加到列表")
                self.requestState = .purchasing;
                self.timer = Timer.dy_scheduledWeakTimer(withTimeInterval: 1.0, target: self, selector: #selector(timerFire), userInfo: [:], repeats: true);
                timeoutInterval = 60;
                break;
            case SKPaymentTransactionState.purchased:
                print("DYPurchasePayState ------ 充值成功！")
                self.timer?.invalidate();
                self.timeoutInterval = 60;
                self.requestState = .purchased;
                self.completedPayTransaction(currentTransaction);
                break;
            case SKPaymentTransactionState.restored:
                print("DYPurchasePayState ------ 重复交易！")
                self.requestState = .purchaseResubmit;
                let err = NSError.init(domain: "重复提交！", code: self.requestState?.rawValue ?? -1, userInfo: nil);
                self.requestCallback?(nil,err);
                self.requestCallback = nil;
                SKPaymentQueue.default().finishTransaction(currentTransaction);
                
                break;
            case SKPaymentTransactionState.failed:
                print("DYPurchasePayState ------ 充值失败%@", currentTransaction.error?.localizedDescription);
                self.requestState = .purchaseFailed;
                let err = NSError.init(domain: "充值失败！", code: self.requestState?.rawValue ?? -1, userInfo: nil);
                self.requestCallback?(nil,err);
                self.requestCallback = nil;
                SKPaymentQueue.default().finishTransaction(currentTransaction);
                
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
        
        
        print("transaction------------%@",transaction.transactionIdentifier as Any);
        print("transaction------------%@",transaction.payment.productIdentifier);
        print("transaction------------%@",transaction.transactionDate as Any);
        print("transaction------------%@",transaction.payment.quantity);
        
        
        // 验证凭据，获取到苹果返回的交易凭据
        // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
        if let receiptURL = Bundle.main.appStoreReceiptURL {
            // 从沙盒中获取到购买凭据
            let receiptData = try? Data.init(contentsOf: receiptURL);
            
            
            self.transactionIdentifier = transaction.transactionIdentifier;
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
        
        print("--------------收到产品反馈消息---------------------")
        let product = response.products;
        print("productID:\(response.invalidProductIdentifiers)")
        if product.count == 0 {
            self.requestState = .unfoundProductor;
            let err = NSError.init(domain: "没有找到对应的支付商品！", code: self.requestState?.rawValue ?? -1, userInfo: nil);
            self.requestCallback?(nil,err);
            return
        }
        
        var p = SKProduct()
        for pro in product {
            print(pro.description)
            print(pro.localizedTitle)
            print(pro.localizedDescription)
            print(pro.price)
            print(pro.productIdentifier)
            
            if pro.productIdentifier == pro.productIdentifier {
                p = pro
            }
            
            let payment = SKPayment(product: p)
            print("发送购买请求")
            SKPaymentQueue.default().add(payment)
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
               //默认数组中最后一个才是当前成功的标准，因为一个票据会包含多个
                var chargeResult = false;
                var haveOtherSuccessed = false;
                if let transactions = result["transactions"] as? [[String : Any]] {
                    
                    for (index,item) in transactions.enumerated() {
                        
                        if let id = item["transactionId"] as? String,let flag = item["status"] as? Int {
                            
                            if flag == 1 {
                                if let transaction = self.localTransactions[id] {
                                    SKPaymentQueue.default().finishTransaction(transaction);
                                }
                                self.localTransactions.removeValue(forKey: id);
                                if index == transactions.count - 1 {
                                    //最后一个是成功的就算成功
                                    chargeResult = true;
                                } else {
                                    haveOtherSuccessed = true;
                                }
                                
                            }
                        }
                    }
                }
                
                print("请求成功：%@",result);
                self.requestState = chargeResult ? .chargeSuccessed : . purchaseFailed;
                if chargeResult {
                    self.requestCallback?(result,nil);
                    NotificationCenter.default.post(name: .init(dy_Notification_purchase_chargeSuccessed), object: response);
                } else {
                    //只要有其中一个成功就通知外面
                    if haveOtherSuccessed {
                        NotificationCenter.default.post(name: .init(dy_Notification_purchase_chargeSuccessed), object: response);
                    }
                    let error = NSError.init(domain: "二次票据验证失败", code: -1, userInfo: nil)
                    self.requestCallback?(nil,error);
                }
               
            } else {
                
                print("内购票据验证失败： %@", response ?? "");
                self.requestState = .chargeFaild;
                let err = NSError.init(domain: error?.errorMessage ?? "充值失败！", code: self.requestState?.rawValue ?? -1, userInfo: nil);
                self.requestCallback?(nil,err);
            }
            self.requestCallback = nil;

        }
      
        
    }
    
}




extension DYPurchaseManager {
  
   
    
    
    
    
    private func testVeriyMyself(dataStr: String) {
        
//        // 存储收据环境的变量
//        let environment = "environment=Sandbox";
//
//        var StoreURL: URL?
//        if (environment == "environment=Sandbox") {
//            StoreURL = URL.init(string: "https://sandbox.itunes.apple.com")
//        }
//        else {
//            StoreURL = URL.init(string:"https://buy.itunes.apple.com");
//        }
//
//        let httpRequest = DYBaseNetwork.init();
//        httpRequest.dy_requestMethod = .POST;
//        httpRequest.dy_requestTimeout = 50;
//        httpRequest.dy_requestArgument = [
//            "receipt-data" : dataStr
//        ];
//        httpRequest.dy_baseURL = StoreURL?.absoluteString ?? "";
//        httpRequest.dy_requestUrl = "/verifyReceipt";
//        httpRequest.dy_requestSerializerType = .JSON;
//        httpRequest.dy_responseSerializerType = .JSON;
//        httpRequest.startWithCompletionBlock(success: { (request) in
//
//
//            if let response = request.responseJSONObject as? [String : Any] {
//
//
//                //这里可以等待上面请求的数据完成后并且state = 0 验证凭据成功来判断后进入自己服务器逻辑的判断,也可以直接进行服务器逻辑的判断,验证凭据也就是一个安全的问题。楼主这里没有用state = 0 来判断。
//                //  [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
//                /*
//                 /**
//                 * 服务器二次验证代码
//                 * 21000 App Store不能读取你提供的JSON对象
//                 * 21002 receipt-data域的数据有问题
//                 * 21003 receipt无法通过验证
//                 * 21004 提供的shared secret不匹配你账号中的shared secret
//                 * 21005 receipt服务器当前不可用
//                 * 21006 receipt合法，但是订阅已过期。服务器接收到这个状态码时，receipt数据仍然会解码并一起发送
//                 * 21007 receipt是Sandbox receipt，但却发送至生产系统的验证服务
//                 * 21008 receipt是生产receipt，但却发送至Sandbox环境的验证服务
//                 */
//                 */
//                if let status = response["status"] as? Int, status == 0 {
//
//
//
//                } else {
//
//                    print("内购票据验证失败： %@", response);
//                    self.requestState = .chargeFaild;
//                    let err = NSError.init(domain: "充值失败！", code: self.requestState?.rawValue ?? -1, userInfo: nil);
//                    self.requestCallback?(nil,err);
//                }
//
//
//            }
//
//        }) { (request) in
//            self.requestState = .chargeFaild;
//            let err = NSError.init(domain: "充值失败！", code: self.requestState?.rawValue ?? -1, userInfo: nil);
//            self.requestCallback?(nil,err);
//            print("验证购买过程中发生错误，错误信息：%@",request.error);
//        }
        
    }
}
