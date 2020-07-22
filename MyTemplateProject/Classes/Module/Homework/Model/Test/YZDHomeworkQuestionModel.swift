//  Created by hansen 



import Foundation 
import ObjectMapper 





class YZDHomeworkQuestionModel: Mappable {



        /**5*/
        var dy_id: Int?

        /**2020-07-13 07:54:33*/
        var dy_createDate: String?

        /**111*/
        var dy_classTypeId: Int?

        /**254652*/
        var dy_questionId: Int?

        /**B*/
        var dy_answer: String?

        /**{
    answer = A;
    difficultId = 1;
    difficultName = "\U5bb9\U6613";
    explanation = "\U3010\U89e3\U7b54\U3011\U65f6\U9488\U8d70\U4e00\U4e2a\U5927\U683c\U5c31\U662f\U4e00\U65f6\U3002 <br>\U3010\U5206\U6790\U3011\U8003\U5bdf\U949f\U9762\U7684\U8ba4\U8bc6";
    isRight = mixed;
    myAnswer = mixed;
    optionNum = mixed;
    options = "";
    optionsJson =     (
                {
            A = "\U4e00\U65f6";
            B = "\U4e94\U5206";
            C = "\U4e94\U65f6";
        }
    );
    optionsMap =     (
                {
            A = "\U4e00\U65f6";
        },
                {
            B = "\U4e94\U5206";
        },
                {
            C = "\U4e94\U65f6";
        }
    );
    parentId = 0;
    questionId = 254652;
    questionTypeId = 1;
    questionTypeName = "\U5355\U9009\U9898";
    score = mixed;
    selected = mixed;
    seq = mixed;
    stem = "\U65f6\U9488\U8d70\U4e00\U4e2a\U5927\U683c\U5c31\U662f\Uff08\Uff09\Uff1f";
    subsets = mixed;
}*/
        var dy_question: YZDHomeworkQuestionModel_question?





        required init?(map: Map) {}








        func mapping(map: Map) {


            dy_id <- map["id"]
            dy_createDate <- map["createDate"]
            dy_classTypeId <- map["classTypeId"]
            dy_questionId <- map["questionId"]
            dy_answer <- map["answer"]
            dy_question <- map["question"]

        }

}