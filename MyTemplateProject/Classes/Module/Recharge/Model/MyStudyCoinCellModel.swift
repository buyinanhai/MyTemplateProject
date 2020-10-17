//
//  MyStudyCoinCellModel.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/9/14.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit
import ObjectMapper

class MyStudyCoinCellModel: Mappable {    
    /*
     "orderNum":"mixed",                //类型：Mixed  必有字段  备注：无
                    "userId":2983461,                //类型：Number  必有字段  备注：无
                    "name":"mixed",                //类型：Mixed  必有字段  备注：无
                    "mobile":"mixed",                //类型：Mixed  必有字段  备注：无
                    "changeTime":"1600336053000",                //类型：String  必有字段  备注：变化时间
                    "changeType":3,                //类型：Number  必有字段  备注：币变更类型 1:充值 ；2:消耗 ；3:回收
                    "changeValue":-20,                //类型：Number  必有字段  备注：学币变动值 (增加为正数,减少为负数)
                    "changeAfter":45.14,                //类型：Number  必有字段  备注：无
                    "commodityName":"mixed",                //类型：Mixed  必有字段  备注：无
                    "changeDes":"学币回收"                //类型：String  必有字段  备注：变化描述
     
     */
    var changeTime: String?
    var changeValue: Double?
    var changeDes: String?
    //1:充值 ；2:消耗 ；3:回收
    var changeType: Int?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        changeTime <- map["changeTime"]
        changeValue <- map["changeValue"]
        changeDes <- map["changeDes"]
        changeType <- map["changeType"]
    }
}
