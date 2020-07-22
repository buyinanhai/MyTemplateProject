//  Created by hansen 



import Foundation 
import ObjectMapper 




/**
课程作业章节列表model中的作业
*/
class YZDHomeworkChapterSectionModel_afterWorks: Mappable {



        /**1：直播；2：录播*/
        var dy_sectionType: String?

        /**
         0:未完成 1：已完成 2：未开始
        */
        var dy_isBegin: Int?

        /**38.5*/
        var dy_accuracy: String?

        /**课堂作业-测试录播*/
        var dy_title: String?

        /**942653*/
        var dy_classTypeId: Int?

        /**1：未发布；2：已发布*/
        var dy_status: Int?

        /**6*/
        var dy_id: Int?

        /**5*/
        var dy_finishCount: Int?

        /**mixed*/
        var dy_teacherId: String?

        /**0*/
        var dy_delFlag: Int?

        /**1*/
        var dy_classSectionId: Int?

        /**13*/
        var dy_questionCount: Int?

        /**mixed*/
        var dy_rightCount: String?





        required init?(map: Map) {}








        func mapping(map: Map) {


            dy_sectionType <- map["sectionType"]
            dy_isBegin <- map["isBegin"]
            dy_accuracy <- map["accuracy"]
            dy_title <- map["title"]
            dy_classTypeId <- map["classTypeId"]
            dy_status <- map["status"]
            dy_id <- map["id"]
            dy_finishCount <- map["finishCount"]
            dy_teacherId <- map["teacherId"]
            dy_delFlag <- map["delFlag"]
            dy_classSectionId <- map["classSectionId"]
            dy_questionCount <- map["questionCount"]
            dy_rightCount <- map["rightCount"]

        }

}
