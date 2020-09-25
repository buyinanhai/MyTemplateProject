//
//  YZDHomeworkNetwork.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/7/17.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit
@_exported import DYTemplate

public class YZDHomeworkNetwork: DYBaseNetwork {

    
    override init() {
        
        super.init();
        self.ignoreCache = false;
        
    }
    
    class private  var  hostUrl: String {
        
        get {
            return "http://test.sdk.live.cunwedu.com.cn";

           return DYNetworkConfig.share()?.networkBaseURL == nil ?  "http://192.168.10.243:8082" :  DYNetworkConfig.share()!.networkBaseURL;
        }
        
    }
    
    class private var isTest: Bool {
        
        get {
            
            return self.hostUrl.contains("test.sdk");
            
        }
    }
    class private var relativeUrl: String {
        
        get {
            return "\(self.isTest ? "" : "")/appApi"
        }
    }
    
    class private var token: String {
        
        get {
            
            return "SRn55wqmX042EufVj3%2FrtZHGsj2Y2129cvHaYmtmkiGFJtUJ4Rm%2BfCl8GunN2fJgISjQcKn5nleB%0AMSP5z7uJZ9ADbCuuwJgX";
            if let token = DYNetworkConfig.share()?.extraData["token"] as? String {
                return token;
            } else {
                return "SRn55wqmX0525NN4xsdDnTOjlqPw9LW3";
            }
        }
        
    }
    class private var userId: Int {
        
        
        get {
            
            return 2984931;
            if let userId = DYNetworkConfig.share()?.extraData["userId"] as? Int {
                return userId;
            } else {
                return 2983482;
            }
            
        }
        
    }
    
    //MARK:我的作业
     
    public class func getMyHomework(page: Int, pageSize: Int) -> YZDHomeworkNetwork {
        
        let obj = YZDHomeworkNetwork.init();
        obj.dy_baseURL = self.hostUrl;
        obj.dy_requestUrl = "\(self.relativeUrl)/afterWork/my-after-work";
        obj.dy_requestArgument = [
            "userId": self.userId,
            "token" : self.token,
            "page" : page,
            "pageSize": pageSize
        ];
        obj.dy_requestMethod = .POST;
        obj.dy_requestSerializerType = .JSON;
        obj.dy_responseSerializerType = .JSON;
        
        
        
        return obj;
    }
    
    //MARK:答题记录
     
    public class func getMyHistoryHomework() -> YZDHomeworkNetwork {
        
        let obj = YZDHomeworkNetwork.init();
        obj.dy_baseURL = self.hostUrl;
        obj.dy_requestUrl = "\(self.relativeUrl)/afterWork/historyWork";
        obj.dy_requestArgument = [
           "userId": self.userId,
            "token" : self.token,
        ];
        obj.dy_requestMethod = .POST;
        obj.dy_requestSerializerType = .JSON;
        obj.dy_responseSerializerType = .JSON;
        
        
        return obj;
    }
    
    //MARK:答题记录详情
     
      
     
    public class func getMyHistoryHomeworkDetail(homeworkId: Int, finishedHomeworkId: Int) -> YZDHomeworkNetwork {
        
        let obj = YZDHomeworkNetwork.init();
        obj.dy_baseURL = self.hostUrl;
        obj.dy_requestUrl = "\(self.relativeUrl)/afterWork/after-work/analysis";
        obj.dy_requestArgument = [
           "userId": self.userId,
            "token" : self.token,
            "afterWorkId": homeworkId,
            "afterWorkFinishId": finishedHomeworkId
        ];
        obj.dy_requestMethod = .POST;
        obj.dy_requestSerializerType = .JSON;
        obj.dy_responseSerializerType = .JSON;
        
        
        return obj;
    }
    
    //MARK:   查询课程的作业
    /*
     classtypeid == productId
     iveFlag= 0 && videoFlag =1是录播课  video， liveFlag= 1 && videoFlag =0是直播课 live ，liveFlag= 1 && videoFlag =1是混合课 blend
     classModuleId   章节id
     */
        
    public class func getHomeworkFromCourse(classTypeId: Int, liveOrVideo: String,classModuleId : Int) -> YZDHomeworkNetwork {
           
           let obj = YZDHomeworkNetwork.init();
           obj.dy_baseURL = self.hostUrl;
           obj.dy_requestUrl = "\(self.relativeUrl)/afterWork/class-type/after-works";
           obj.dy_requestArgument = [
               "userId": self.userId,
               "token" : self.token,
                "classTypeId": classTypeId,
                          "liveOrVideo": liveOrVideo,
                          "classModuleId": classModuleId
           ];
           obj.dy_requestMethod = .POST;
           obj.dy_requestSerializerType = .JSON;
           obj.dy_responseSerializerType = .JSON;
           
           
           return obj;
       }
    //MARK:获取课程章节
     
    public class func getChapterFromCourse(classTypeId: Int, liveOrVideo: String) -> YZDHomeworkNetwork {
        
        let obj = YZDHomeworkNetwork.init();
        obj.dy_baseURL = self.hostUrl;
        obj.dy_requestUrl = "\(self.relativeUrl)/afterWork/getModule";
        obj.dy_requestArgument = [
            
            "classTypeId": classTypeId,
            "liveOrVideo": liveOrVideo
        ];
        obj.dy_requestMethod = .GET;
        obj.dy_requestSerializerType = .JSON;
        obj.dy_responseSerializerType = .JSON;
        
        
        return obj;
    }
    
 
    
    
   
    //MARK:获取作业中的题目
    //开始做作业     
    public class func getQuestionsFromCourse(afterWorkId: Int) -> YZDHomeworkNetwork {

        let obj = YZDHomeworkNetwork.init();
        obj.dy_baseURL = self.hostUrl;
        obj.dy_requestUrl = "\(self.relativeUrl)/afterWork/after-work/questions";
        obj.dy_requestArgument = [
            "userId": 2983482,
            "token" : "SRn55wqmX05xTJlnCOePBRp75bE8Ch7N",
            "afterWorkId": afterWorkId,
          
        ];
        obj.dy_requestMethod = .POST;
        obj.dy_requestSerializerType = .JSON;
        obj.dy_responseSerializerType = .JSON;
        
        
        return obj;
    }
    
    
    //MARK:   查询学科
         
        
       public class func getMysSubjects(stagedId: Int) -> YZDHomeworkNetwork {

           let obj = YZDHomeworkNetwork.init();
           obj.dy_baseURL = self.hostUrl;
           obj.dy_requestUrl = "\(self.relativeUrl)/resource/subjects";
           obj.dy_requestArgument = [
               "stageId": stagedId,
           ];
           obj.dy_requestMethod = .GET;
           obj.dy_requestSerializerType = .JSON;
           obj.dy_responseSerializerType = .JSON;
           
           
           return obj;
       }
    
    //MARK:   查询年级
         
        
       public class func getMyGrades() -> YZDHomeworkNetwork {

           let obj = YZDHomeworkNetwork.init();
           obj.dy_baseURL = self.hostUrl;
           obj.dy_requestUrl = "\(self.relativeUrl)/resource/grades";
           obj.dy_requestMethod = .GET;
           obj.dy_requestSerializerType = .JSON;
           obj.dy_responseSerializerType = .JSON;
           
           return obj;
       }
    
    
    
     //MARK: 我的错题集
    /*
     subjectId  : 科目id
     
     gradeId:   年级id
     */
      
     public class func getMyErrorCollections(classTypeId: Int,subjectId : String?, gradeId: Int?,page: Int, pageSize: Int) -> YZDHomeworkNetwork {

         let obj = YZDHomeworkNetwork.init();
         obj.dy_baseURL = self.hostUrl;
         obj.dy_requestUrl = "\(self.relativeUrl)/afterWork/wrong-collection";
         obj.dy_requestArgument = [
            "userId": self.userId,
            "token" : self.token,
             "classTypeId": classTypeId,
             "subjectId": subjectId ?? "",
             "gradeId" : gradeId ?? 0,
             "page": page,
             "pageSize": pageSize
             
         ];
        if classTypeId == 0 {
            obj.dy_requestArgument = [
                "userId": self.userId,
                "token" : self.token,
                "page": page,
                "pageSize": pageSize,
                "subjectId": subjectId ?? "",
                "gradeId" : gradeId ?? 0,
            ];
            if (subjectId == nil) {
                obj.dy_requestArgument = [
                    "userId": self.userId,
                    "token" : self.token,
                    "page": page,
                    "pageSize": pageSize
                ];
            }
        } else if subjectId == nil || gradeId == nil  {
            
            obj.dy_requestArgument = [
                "userId": self.userId,
                "token" : self.token,
                "classTypeId": classTypeId,
                "page": page,
                "pageSize": pageSize
            ];
        }
         obj.dy_requestMethod = .POST;
         obj.dy_requestSerializerType = .JSON;
         obj.dy_responseSerializerType = .JSON;
         
         
         return obj;
     }
     
    
    //MARK:移出错题集
      
     
    public class func removeQuestionsFromCollections(questionIds: [Int]) -> YZDHomeworkNetwork {

        let obj = YZDHomeworkNetwork.init();
        obj.dy_baseURL = self.hostUrl;
        obj.dy_requestUrl = "\(self.relativeUrl)/afterWork/removewrong";
        
        obj.dy_requestArgument = [
            "userId": self.userId,
            "token" : self.token,
            "questionIds": questionIds,
        ];
        obj.dy_requestMethod = .POST;
        obj.dy_requestSerializerType = .JSON;
        obj.dy_responseSerializerType = .JSON;
        
        
        return obj;
    }
    
    //MARK:       获取作业试题
         
        
       public class func getHomeworkQuestions(afterWorkId: Int) -> YZDHomeworkNetwork {

           let obj = YZDHomeworkNetwork.init();
           obj.dy_baseURL = self.hostUrl;
           obj.dy_requestUrl = "\(self.relativeUrl)/afterWork/after-work/questions";
           
           obj.dy_requestArgument = [
               "userId": self.userId,
               "token" : self.token,
               "afterWorkId": afterWorkId,
           ];
           obj.dy_requestMethod = .POST;
           obj.dy_requestSerializerType = .JSON;
           obj.dy_responseSerializerType = .JSON;
           
           
           return obj;
       }
    
     
    //MARK:收藏题目
      
     
    public class func collectQuestion(afterWorkId: Int?,questionId: Int,likeOrUnlike: Int) -> YZDHomeworkNetwork {

        let obj = YZDHomeworkNetwork.init();
        obj.dy_baseURL = self.hostUrl;
        obj.dy_requestUrl = "\(self.relativeUrl)/afterWork/like-question";
        
        if afterWorkId == nil {
            obj.dy_requestArgument = [
                "userId": self.userId,
                "token" : self.token,
                "questionId":questionId,
                "likeOrUnlike": likeOrUnlike == 1 ? 0 : 1
            ];
        } else {
            obj.dy_requestArgument = [
                "userId": self.userId,
                "token" : self.token,
                "afterWorkId": afterWorkId!,
                "questionId":questionId,
                "likeOrUnlike": likeOrUnlike == 1 ? 0 : 1
            ];
        }
        
        obj.dy_requestMethod = .POST;
        obj.dy_requestSerializerType = .JSON;
        obj.dy_responseSerializerType = .JSON;
        
        
        return obj;
    }
    
    //MARK:提交答案
      
     
    public class func commitAnswers(afterWorkId: Int,usedTime: Int,answers: [[String : String]]) -> YZDHomeworkNetwork {

        let obj = YZDHomeworkNetwork.init();
        obj.dy_baseURL = self.hostUrl;
        obj.dy_requestUrl = "\(self.relativeUrl)/afterWork/after-work/finish";
        
        obj.dy_requestArgument = [
            "userId": self.userId,
            "token" : self.token,
            "afterWorkId": afterWorkId,
            "usedTime":usedTime,
            "answers": answers
        ];
        obj.dy_requestMethod = .POST;
        obj.dy_requestSerializerType = .JSON;
        obj.dy_responseSerializerType = .JSON;
        
        return obj;
    }
    
    //MARK:   获取答题结果
    public class func getMyHomeworkResult(afterWorkId: Int,afterWorkFinishId: Int) -> YZDHomeworkNetwork {

           let obj = YZDHomeworkNetwork.init();
           obj.dy_baseURL = self.hostUrl;
           obj.dy_requestUrl = "\(self.relativeUrl)/afterWork/after-work/analysis";
           
           obj.dy_requestArgument = [
               "userId": self.userId,
               "token" : self.token,
               "afterWorkId": afterWorkId,
               "afterWorkFinishId":afterWorkFinishId,
           ];
           obj.dy_requestMethod = .POST;
           obj.dy_requestSerializerType = .JSON;
           obj.dy_responseSerializerType = .JSON;
           
           return obj;
       }
    
}
