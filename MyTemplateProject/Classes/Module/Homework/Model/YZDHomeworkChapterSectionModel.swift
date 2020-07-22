//  Created by hansen 



import Foundation 
import ObjectMapper 




/**
 课程作业章节列表model
 */
class YZDHomeworkChapterSectionModel: Mappable {



        /**(
        {
        accuracy = "38.5";
        classSectionId = 1;
        classTypeId = 942653;
        delFlag = 0;
        finishCount = 5;
        id = 6;
        isBegin = 1;
        questionCount = 13;
        rightCount = mixed;
        sectionType = mixed;
        status = 2;
        teacherId = mixed;
        title = "\U8bfe\U5802\U4f5c\U4e1a-\U6d4b\U8bd5\U5f55\U64ad";
    }
)*/
        var dy_afterWorks: [YZDHomeworkChapterSectionModel_afterWorks]?

        /**录播1*/
        var dy_lessonName: String?

        /**1*/
        var dy_id: Int?





        required init?(map: Map) {}








        func mapping(map: Map) {


            dy_afterWorks <- map["afterWorks"]
            dy_lessonName <- map["lessonName"]
            dy_id <- map["id"]

        }

}
