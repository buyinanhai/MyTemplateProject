//  Created by hansen 



import Foundation 
import ObjectMapper 





class YZDHomeworkQuestionModel_optionsJson: Mappable {



        /**一时*/
        var dy_A: String?

        /**五分*/
        var dy_B: String?

        /**五时*/
        var dy_C: String?





        required init?(map: Map) {}








        func mapping(map: Map) {


            dy_A <- map["A"]
            dy_B <- map["B"]
            dy_C <- map["C"]

        }

}