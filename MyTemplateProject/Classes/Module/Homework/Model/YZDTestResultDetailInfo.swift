//  Created by hansen 



import Foundation 
import ObjectMapper 



/**
 答题记录详情的model
 */
class YZDTestResultDetailInfo: Mappable {



        /**4*/
        var dy_questionCount: Int?

        /**mixed*/
        var dy_teacherId: String?

        /**50*/
        var dy_accuracy: String?

        /**4*/
        var dy_finishCount: Int?

        /**942653*/
        var dy_classTypeId: Int?

        /**课堂作业-测试录播*/
        var dy_title: String?

        /**1110000*/
        var dy_usedTime: Int?

        /**1*/
        var dy_classSectionId: Int?

        /**mixed*/
        var dy_isBegin: String?

        /**0*/
        var dy_delFlag: Int?

        /**mixed*/
        var dy_sectionType: String?

        /**8*/
        var dy_id: Int?

        /**2*/
        var dy_rightCount: Int?

        /**2*/
        var dy_status: Int?


        required init?(map: Map) {}



        func mapping(map: Map) {


            dy_questionCount <- map["questionCount"]
            dy_teacherId <- map["teacherId"]
            dy_accuracy <- map["accuracy"]
            dy_finishCount <- map["finishCount"]
            dy_classTypeId <- map["classTypeId"]
            dy_title <- map["title"]
            dy_usedTime <- map["usedTime"]
            dy_classSectionId <- map["classSectionId"]
            dy_isBegin <- map["isBegin"]
            dy_delFlag <- map["delFlag"]
            dy_sectionType <- map["sectionType"]
            dy_id <- map["id"]
            dy_rightCount <- map["rightCount"]
            dy_status <- map["status"]

        }

}
