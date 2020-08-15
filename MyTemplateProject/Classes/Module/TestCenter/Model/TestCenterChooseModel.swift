//
//  TestCenterChooseModel.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/8/12.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit
import ObjectMapper


/**
 章节目录下的节点模型
 */
class TestCenterNodeModel: Mappable, NSCopying  {
    func copy(with zone: NSZone? = nil) -> Any {
        
        let node = TestCenterNodeModel.init(JSON: self.toJSON());
//        node?.dy_id = self.dy_id;
//        node?.dy_title = self.dy_title;
//        node?.dy_seq = self.dy_seq;
//        node?.dy_totalCount = self.dy_totalCount;
//        node?.dy_finishCount = self.dy_finishCount;
        node?.dy_isUnfold = self.dy_isUnfold;
        node?.dy_level = self.dy_level;
        node?.dy_isSelect = self.dy_isSelect;
        node?.dy_children = self.dy_children?.map({ (model) -> TestCenterNodeModel in
            return model.copy() as! TestCenterNodeModel
        })
        return node as Any;
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        dy_title <- map["title"]
        dy_id <- map["id"]
        dy_seq <- map["seq"]
        dy_totalCount <- map["totalCount"]
        dy_finishCount <- map["finishCount"]
        dy_children <- map["children"]

    }
    
    var dy_title: String?
    var dy_id: String?
    var dy_seq: String?
    var dy_totalCount: Int?
    var dy_finishCount: Int?
//    var dy_children: [TestCenterNodeModel]?
    ///父节点
    var dy_parent: TestCenterNodeModel?
    ///子节点
    var dy_children: [TestCenterNodeModel]?
    ///是否展开
    var dy_isUnfold: Bool = false;
    ///是否选中
    var dy_isSelect: Bool = false;    
    ///节点层级
    var dy_level: Int = 1;
//    ///是否为根 如果是  则有子节点
//    var dy_isRoot: Bool = true;
//    ///是否为叶 如果是  则没有子节点
//    var dy_isLeaf: Bool = true;

    
}

