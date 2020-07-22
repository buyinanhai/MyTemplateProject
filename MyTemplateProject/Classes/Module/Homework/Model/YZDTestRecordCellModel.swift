//
//  YZDTestRecordCellModel.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/7/17.
//  Copyright © 2020 汪宁. All rights reserved.
//


import Foundation
import ObjectMapper


class YZDTestRecordCellModel: Mappable {

        /**30*/
        var dy_afterWorkFinishId: Int?

        /**0*/
        var dy_accuracy: String?

        /**1*/
        var dy_moduleId: Int?

        /**撒旦法*/
        var dy_moduleName: String?

        /**8*/
        var dy_afterWorkId: Int?

        /**1594881850000*/
        var dy_createDate: Int?

        /**1*/
        var dy_classSectionId: Int?

        /**4*/
        var dy_finishCount: Int?

        /**942653*/
        var dy_classTypeId: Int?

        /**0*/
        var dy_rightCount: Int?

        /**录播1*/
        var dy_lessonName: String?

        /**第三方的士大夫*/
        var dy_classTypeName: String?

        /**98781*/
        var dy_usedTime: Int?

        required init?(map: Map) {}

        func mapping(map: Map) {


            dy_afterWorkFinishId <- map["afterWorkFinishId"]
            dy_accuracy <- map["accuracy"]
            dy_moduleId <- map["moduleId"]
            dy_moduleName <- map["moduleName"]
            dy_afterWorkId <- map["afterWorkId"]
            dy_createDate <- map["createDate"]
            dy_classSectionId <- map["classSectionId"]
            dy_finishCount <- map["finishCount"]
            dy_classTypeId <- map["classTypeId"]
            dy_rightCount <- map["rightCount"]
            dy_lessonName <- map["lessonName"]
            dy_classTypeName <- map["classTypeName"]
            dy_usedTime <- map["usedTime"]

        }

}

