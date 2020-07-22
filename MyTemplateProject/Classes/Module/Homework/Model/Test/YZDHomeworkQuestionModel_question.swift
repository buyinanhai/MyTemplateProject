//  Created by hansen 



import Foundation 
import ObjectMapper 





class YZDHomeworkQuestionModel_question: Mappable {



        /**mixed*/
        var dy_selected: String?

        /**mixed*/
        var dy_seq: String?

        /**1*/
        var dy_questionTypeId: Int?

        /**mixed*/
        var dy_score: String?

        /**254652*/
        var dy_questionId: Int?

        /**A*/
        var dy_answer: String?

        /***/
        var dy_options: String?

        /**mixed*/
        var dy_optionNum: String?

        /**0*/
        var dy_parentId: Int?

        /**【解答】时针走一个大格就是一时。 <br>【分析】考察钟面的认识*/
        var dy_explanation: String?

        /**1*/
        var dy_difficultId: Int?

        /**mixed*/
        var dy_myAnswer: String?

        /**mixed*/
        var dy_isRight: String?

        /**单选题*/
        var dy_questionTypeName: String?

        /**容易*/
        var dy_difficultName: String?

        /**(
        {
        A = "\U4e00\U65f6";
    },
        {
        B = "\U4e94\U5206";
    },
        {
        C = "\U4e94\U65f6";
    }
)*/
        var dy_optionsMap: [YZDHomeworkQuestionModel_optionsMap]?

        /**mixed*/
        var dy_subsets: String?

        /**时针走一个大格就是（）？*/
        var dy_stem: String?

        /**(
        {
        A = "\U4e00\U65f6";
        B = "\U4e94\U5206";
        C = "\U4e94\U65f6";
    }
)*/
        var dy_optionsJson: [YZDHomeworkQuestionModel_optionsJson]?





        required init?(map: Map) {}








        func mapping(map: Map) {


            dy_selected <- map["selected"]
            dy_seq <- map["seq"]
            dy_questionTypeId <- map["questionTypeId"]
            dy_score <- map["score"]
            dy_questionId <- map["questionId"]
            dy_answer <- map["answer"]
            dy_options <- map["options"]
            dy_optionNum <- map["optionNum"]
            dy_parentId <- map["parentId"]
            dy_explanation <- map["explanation"]
            dy_difficultId <- map["difficultId"]
            dy_myAnswer <- map["myAnswer"]
            dy_isRight <- map["isRight"]
            dy_questionTypeName <- map["questionTypeName"]
            dy_difficultName <- map["difficultName"]
            dy_optionsMap <- map["optionsMap"]
            dy_subsets <- map["subsets"]
            dy_stem <- map["stem"]
            dy_optionsJson <- map["optionsJson"]

        }

}