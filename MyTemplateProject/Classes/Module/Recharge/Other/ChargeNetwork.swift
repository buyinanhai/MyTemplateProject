//
//  ChargeNetwork.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/9/17.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit

class ChargeNetwork: DYBaseNetwork {

    
    class private var hostUrl: String {
        
        get {
            return "http://test.sdk.live.cunwedu.com.cn";
            return "http://192.168.11.195:8082";
        }
    }
    
    class private var token: String {
        
        get {
            
            return "SRn55wqmX05%2FiDa%2Fun%2BVvgkjepSA%2BLtMYZjV9QhS%2B7l9u6WuU3CCcwyyWgbVPcNsDbFLAHXNYtsh%0A4CHxoU76rmc74nPV%2F0Q2";
            
            if let token = DYNetworkConfig.share()?.extraData["token"] as? String {
                return token;
            } else {
                return "1%2B6Eifdnurv%2BwIXACMLMLsZZe75nzv8P6ZeQAVm%2FSgSvGSgIN1DqBehPdNANo5Jsg7bb0r5%2BUfqP%0A2SiEriu%2BvKFFqIIFT%2FgA";
            }
        }
        
    }
    class private var userId: Int {
        
        get {
            return 2984931;
            if let userId = DYNetworkConfig.share()?.extraData["userId"] as? Int {
                return userId;
            } else {
                return 2984573;
            }
            
        }
        
    }
    
    class private var isTest: Bool {
        
        get {
            
            return self.hostUrl.contains("test.sdk");
            
        }
    }
    class private var relativeUrl: String {
        
        get {
            return "\(self.isTest ? "" : "")/appApi"
        }
    }
    
    //MARK: 获取充值学币的配置
    public class func getChargeList() -> ChargeNetwork {
        
        let obj = ChargeNetwork.init();
        obj.dy_baseURL = self.hostUrl;
        obj.dy_requestUrl = "\(self.relativeUrl)/coin-configs";
        obj.dy_requestArgument = [
            "token" : self.token,
        ];
        obj.dy_requestMethod = .POST;
        obj.dy_requestSerializerType = .JSON;
        obj.dy_responseSerializerType = .JSON;
        
        return obj;
    }
    
    public class func verifyPurchase(receiptData: String) -> ChargeNetwork {
        
        let obj = ChargeNetwork.init();
        obj.dy_baseURL = self.hostUrl;
        obj.dy_requestUrl = "\(self.relativeUrl)/payOrder/iap-pay-callback";
        obj.dy_requestArgument = [
            "receipt" : receiptData,
            "token": self.token
        ];
        obj.dy_requestMethod = .POST;
        obj.dy_requestSerializerType = .JSON;
        obj.dy_responseSerializerType = .JSON;
        
        return obj;
        
        
    }
     //MARK: 获取学习币最大值 支付价格不能超过这个接口返回的最大值
       public class func getPriceLimit() -> ChargeNetwork {
        
        
        let obj = ChargeNetwork.init();
        obj.dy_baseURL = self.hostUrl;
        obj.dy_requestUrl = "\(self.relativeUrl)/company/queryFunctionByFunctionCode";
        obj.dy_requestArgument = [
            "code" : "COIN_THRESHOLD",
            "token": self.token
        ];
        obj.dy_requestMethod = .POST;
        obj.dy_requestSerializerType = .JSON;
        obj.dy_responseSerializerType = .JSON;
        
        return obj;
        
        
    }
    
    //MARK: 学币支付订单
    public class func startPay(payType: String, orderId: String) -> ChargeNetwork {
           
           let obj = ChargeNetwork.init();
           obj.dy_baseURL = self.hostUrl;
           obj.dy_requestUrl = "\(self.relativeUrl)/appFinishOrder/\(orderId)";
           obj.dy_requestArgument = [
               "payType" : payType,
               "token": self.token
           ];
           obj.dy_requestMethod = .POST;
           obj.dy_requestSerializerType = .JSON;
           obj.dy_responseSerializerType = .JSON;
           
           return obj;
       }
    //MARK: 学币使用记录表
    public class func getCoinRecordList() -> ChargeNetwork {
       
        let obj = ChargeNetwork.init();
        obj.dy_baseURL = self.hostUrl;
        obj.dy_requestUrl = "\(self.relativeUrl)/order/getMyIosCoin";
        obj.dy_requestArgument = [
            "userId" : self.userId,
            "token": self.token
        ];
        obj.dy_requestMethod = .POST;
        obj.dy_requestSerializerType = .JSON;
        obj.dy_responseSerializerType = .JSON;
        
        return obj;
        
        
    }
}
