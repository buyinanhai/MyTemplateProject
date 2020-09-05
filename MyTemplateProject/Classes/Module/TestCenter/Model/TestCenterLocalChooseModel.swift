//
//  TestCenterLocalChooseModel.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/9/4.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit
import ObjectMapper

class TestCenterLocalChooseModel: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        subjectTitle <- map["subjectTitle"];
        headerTitle <- map["headerTitle"];
        subjectId <- map["subjectId"];
        volumeId <- map["volumeId"];
        chooseOption <- map["chooseOption"];
        
    }
    ///学科id
    public var subjectId: Int = -1;
    //册别id
    public var volumeId: Int = -1;
    public var headerTitle: String?
    public var subjectTitle: String?
    
    /**
     0 : 选择类型
     1： 学段
     2 ： 学科
     3： 年级
     4：版本
     5：册别
     */
    public var chooseOption:[String: Int]?

}
