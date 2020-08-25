//
//  CommonNetwork.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/8/18.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit

class CommonNetwork: DYBaseNetwork {
    
    
    
    
    /**
     创建每日鲜用户
     */
    
    public class func createUser(userName: String, password: String) -> CommonNetwork {
        
        
        let obj = CommonNetwork.init();
        obj.dy_baseURL = "http://127.0.0.1:8083";
        obj.dy_requestUrl = "/admin/admin/create";
        obj.dy_requestArgument = [
            "username": userName,
            "password" : password,
        ];
        obj.dy_requestMethod = .POST;
        obj.dy_requestSerializerType = .JSON;
        obj.dy_responseSerializerType = .JSON;
        
        return obj;
        
        
        
    }
    
    
    
    
    

}
