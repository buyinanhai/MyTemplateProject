//
//  YZDHomeworkNetwork.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/7/17.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit

class YZDHomeworkNetwork: DYBaseNetwork {

    
    override init() {
        
        super.init();
        self.ignoreCache = false;
        
    }
    
    class private var token: String {
        
        get {
            
            return "SRn55wqmX0525NN4xsdDnTOjlqPw9LW3";
            
        }
        
    }
    class private var userId: Int {
        
        get {
            
            return 2983482;
            
        }
        
    }
    
    /**
     我的作业
     */
    public class func getMyHomework(page: Int, pageSize: Int) -> YZDHomeworkNetwork {
        
        let obj = YZDHomeworkNetwork.init();
        obj.dy_baseURL = "http://192.168.10.243:8082";
        obj.dy_requestUrl = "/sdk/appApi/afterWork/my-after-work";
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
    
    /**
     答题记录
     */
    public class func getMyHistoryHomework() -> YZDHomeworkNetwork {
        
        let obj = YZDHomeworkNetwork.init();
        obj.dy_baseURL = "http://192.168.10.243:8082";
        obj.dy_requestUrl = "/sdk/appApi/afterWork/historyWork";
        obj.dy_requestArgument = [
           "userId": self.userId,
            "token" : self.token,
        ];
        obj.dy_requestMethod = .POST;
        obj.dy_requestSerializerType = .JSON;
        obj.dy_responseSerializerType = .JSON;
        
        
        return obj;
    }
    
    /**
     答题记录详情
     
      
     */
    public class func getMyHistoryHomeworkDetail(homeworkId: Int, finishedHomeworkId: Int) -> YZDHomeworkNetwork {
        
        let obj = YZDHomeworkNetwork.init();
        obj.dy_baseURL = "http://192.168.10.243:8082";
        obj.dy_requestUrl = "/sdk/appApi/afterWork/after-work/analysis";
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
    
    /**
        查询课程的作业
        classtypeid == productId
        iveFlag= 0 && videoFlag =1是录播课  video， liveFlag= 1 && videoFlag =0是直播课 live ，liveFlag= 1 && videoFlag =1是混合课 blend
            classModuleId   章节id
        */
    public class func getHomeworkFromCourse(classTypeId: Int, liveOrVideo: String,classModuleId : Int) -> YZDHomeworkNetwork {
           
           let obj = YZDHomeworkNetwork.init();
           obj.dy_baseURL = "http://192.168.10.243:8082";
           obj.dy_requestUrl = "/sdk/appApi/afterWork/class-type/after-works";
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
    /**
     获取课程章节
     */
    public class func getChapterFromCourse(classTypeId: Int, liveOrVideo: String) -> YZDHomeworkNetwork {
        
        let obj = YZDHomeworkNetwork.init();
        obj.dy_baseURL = "http://192.168.10.243:8082";
        obj.dy_requestUrl = "/sdk/appApi/afterWork/getModule";
        obj.dy_requestArgument = [
            
            "classTypeId": classTypeId,
            "liveOrVideo": liveOrVideo
        ];
        obj.dy_requestMethod = .GET;
        obj.dy_requestSerializerType = .JSON;
        obj.dy_responseSerializerType = .JSON;
        
        
        return obj;
    }
    
 
    
    
   
    /**
     获取作业中的题目
    开始做作业
      
     */
    public class func getQuestionsFromCourse(afterWorkId: Int) -> YZDHomeworkNetwork {

        let obj = YZDHomeworkNetwork.init();
        obj.dy_baseURL = "http://192.168.10.243:8082";
        obj.dy_requestUrl = "/sdk/appApi/afterWork/after-work/questions";
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
    
    
    /**
        查询学科
         
        */
       public class func getMysSubjects(stagedId: Int) -> YZDHomeworkNetwork {

           let obj = YZDHomeworkNetwork.init();
           obj.dy_baseURL = "http://192.168.10.243:8082";
           obj.dy_requestUrl = "/sdk/appApi/resource/subjects";
           obj.dy_requestArgument = [
               "stageId": stagedId,
           ];
           obj.dy_requestMethod = .GET;
           obj.dy_requestSerializerType = .JSON;
           obj.dy_responseSerializerType = .JSON;
           
           
           return obj;
       }
    
    /**
        查询年级
         
        */
       public class func getMyGrades() -> YZDHomeworkNetwork {

           let obj = YZDHomeworkNetwork.init();
           obj.dy_baseURL = "http://192.168.10.243:8082";
           obj.dy_requestUrl = "/sdk/appApi/resource/grades";
           obj.dy_requestMethod = .GET;
           obj.dy_requestSerializerType = .JSON;
           obj.dy_responseSerializerType = .JSON;
           
           return obj;
       }
    
    
    
     /**
      我的错题集
      
         subjectId  : 科目id
        gradeId:   年级id
       
      */
     public class func getMyErrorCollections(classTypeId: Int,subjectId : String?, gradeId: Int?,page: Int, pageSize: Int) -> YZDHomeworkNetwork {

         let obj = YZDHomeworkNetwork.init();
         obj.dy_baseURL = "http://192.168.10.243:8082";
         obj.dy_requestUrl = "/sdk/appApi/afterWork/wrong-collection";
         obj.dy_requestArgument = [
            "userId": self.userId,
            "token" : self.token,
             "classTypeId": classTypeId,
             "subjectId": subjectId ?? "",
             "gradeId" : gradeId ?? 0,
             "page": page,
             "pageSize": pageSize
             
         ];
        if subjectId == nil || gradeId == nil {
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
     
    
    /**
     移出错题集
      
     */
    public class func removeQuestionsFromCollections(questionIds: [Int]) -> YZDHomeworkNetwork {

        let obj = YZDHomeworkNetwork.init();
        obj.dy_baseURL = "http://192.168.10.243:8082";
        obj.dy_requestUrl = "/sdk/appApi/afterWork/removewrong";
        
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
}
