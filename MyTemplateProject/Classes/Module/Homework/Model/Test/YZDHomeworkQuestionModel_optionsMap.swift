//  Created by hansen 



import Foundation 
import ObjectMapper 





class YZDHomeworkQuestionModel_optionsMap: Mappable {



        /**一时*/
        var dy_A: String?





        required init?(map: Map) {}








        func mapping(map: Map) {


            dy_A <- map["A"]

        }

}