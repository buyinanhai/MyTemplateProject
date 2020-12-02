//
//  TestCenterNetwork.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/8/10.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit

class TestCenterNetwork: DYBaseNetwork {
    
    class private var hostUrl: String {
        
        get {
            return "http://test.sdk.live.cunwedu.com.cn";
            return "http://192.168.11.195:8082";
        }
    }
    
    class private var token: String {
        
        get {
            
            return "SRn55wqmX042DMxDwB4y1JxoFiW%2BZdcsKKwdYRie%2FeaFJtUJ4Rm%2BfCl8GunN2fJgISjQcKn5nleB%0AMSP5z7uJZ9ADbCuuwJgX";
            
            if let token = DYNetworkConfig.share()?.extraData["token"] as? String {
                return token;
            } else {
                return "1%2B6Eifdnurv%2BwIXACMLMLsZZe75nzv8P6ZeQAVm%2FSgSvGSgIN1DqBehPdNANo5Jsg7bb0r5%2BUfqP%0A2SiEriu%2BvKFFqIIFT%2FgA";
            }
        }
        
    }
    class private var userId: Int {
        
        get {
            return 2984931;
            if let userId = DYNetworkConfig.share()?.extraData["userId"] as? Int {
                return userId;
            } else {
                return 2984573;
            }
            
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
    
    //MARK: 获取科目下的知识点章节
    public class func getKnowledgePoints(from subjectId: Int) -> TestCenterNetwork {
        
        let obj = TestCenterNetwork.init();
        obj.dy_baseURL = self.hostUrl;
        obj.dy_requestUrl = "\(self.relativeUrl)/resource/subject-points/\(subjectId)";
        obj.dy_requestArgument = [
            "userId": self.userId,
            "token" : self.token,
        ];
        obj.dy_requestMethod = .POST;
        obj.dy_requestSerializerType = .JSON;
        obj.dy_responseSerializerType = .JSON;
        
        return obj;
    }

    
    //MARK: 获取册别的章节
    public class func getChapterPoints(fromVolume volumeId: Int) -> TestCenterNetwork {
        
        let obj = TestCenterNetwork.init();
        obj.dy_baseURL = self.hostUrl;
        obj.dy_requestUrl = "\(self.relativeUrl)/resource/book-dirs/\(volumeId)";
        obj.dy_requestArgument = [
            "userId": self.userId,
            "token" : self.token,
        ];
        obj.dy_requestMethod = .POST;
        obj.dy_requestSerializerType = .JSON;
        obj.dy_responseSerializerType = .JSON;
        
        return obj;
    }
    
    
    //MARK: 根据知识点id随机获取题目
    public class func getRandomTests(byKnowledge knowledgeId: String,questionCount: Int, gradeId:Int, subjectId:String) -> TestCenterNetwork {
        
        let obj = TestCenterNetwork.init();
        obj.dy_baseURL = self.hostUrl;
        obj.dy_requestUrl = "\(self.relativeUrl)/resource/questions/by-point";
        obj.dy_requestArgument = [
            "userId": self.userId,
            "token" : self.token,
            "pointId" : knowledgeId,
            "questionCount":questionCount,
            "gradeId":gradeId,
            "subjectId":subjectId,
        ];
        obj.dy_requestMethod = .POST;
        obj.dy_requestSerializerType = .JSON;
        obj.dy_responseSerializerType = .JSON;
        
        return obj;
    }
    
    
    //MARK: 根据目录id随机获取题目
    public class func getRandomTests(byDirectory directoryId: String, questionCount: Int) -> TestCenterNetwork {
        
        let obj = TestCenterNetwork.init();
        obj.dy_baseURL = self.hostUrl;
        obj.dy_requestUrl = "\(self.relativeUrl)/resource/questions/by-dir";
        obj.dy_requestArgument = [
            "userId": self.userId,
            "token" : self.token,
            "dirId" : directoryId,
            "questionCount": questionCount
        ];
        obj.dy_requestMethod = .POST;
        obj.dy_requestSerializerType = .JSON;
        obj.dy_responseSerializerType = .JSON;
        
        return obj;
    }
    
    //MARK: 提交答案
    public class func commitAnswers(answers:[[String: String]], gradeId: Int, subjectId: String, nodeId: String, type: Int) -> TestCenterNetwork {
        
        let obj = TestCenterNetwork.init();
        obj.dy_baseURL = self.hostUrl;
        obj.dy_requestUrl = "\(self.relativeUrl)/topic/submitTopic";
        if type == 1 {
            //章节做题
            obj.dy_requestArgument = [
                "userId": self.userId,
                "token" : self.token,
                "answers" : answers,
                "id": nodeId
            ];
        } else if type == 0 {
            //知识点做题
            obj.dy_requestArgument = [
                "userId": self.userId,
                "token" : self.token,
                "answers" : answers,
                "gradeId": gradeId,
                "subjectId": subjectId,
            ];
        }
        obj.dy_requestMethod = .POST;
        obj.dy_requestSerializerType = .JSON;
        obj.dy_responseSerializerType = .JSON;
        
        return obj;
    }
    
    //MARK: 查询册别
    public class func getVolume(versionId: Int) -> TestCenterNetwork {
        
        let obj = TestCenterNetwork.init();
        obj.dy_baseURL = self.hostUrl;
        obj.dy_requestUrl = "\(self.relativeUrl)/resource/textbooks";
        obj.dy_requestArgument = [
            "userId": self.userId,
            "token" : self.token,
            "versionId" : versionId,
        ];
        obj.dy_requestMethod = .GET;
        obj.dy_requestSerializerType = .JSON;
        obj.dy_responseSerializerType = .JSON;
        
        return obj;
    }
    
    
    //MARK: 查询学段
    public class func getStudyLevel() -> TestCenterNetwork {
        
        let obj = TestCenterNetwork.init();
        obj.dy_baseURL = self.hostUrl;
        obj.dy_requestUrl = "\(self.relativeUrl)/resource/stages";
        obj.dy_requestArgument = [
            "userId": self.userId,
            "token" : self.token,
        ];
        obj.dy_requestMethod = .GET;
        obj.dy_requestSerializerType = .JSON;
        obj.dy_responseSerializerType = .JSON;
        
        return obj;
    }
    
    //MARK: 查询学科
    public class func getStudySubjects(stageId: Int) -> TestCenterNetwork {
        
        let obj = TestCenterNetwork.init();
        obj.dy_baseURL = self.hostUrl;
        obj.dy_requestUrl = "\(self.relativeUrl)/resource/subjects";
        obj.dy_requestArgument = [
            "userId": self.userId,
            "token" : self.token,
            "stageId": stageId,
        ];
        obj.dy_requestMethod = .GET;
        obj.dy_requestSerializerType = .JSON;
        obj.dy_responseSerializerType = .JSON;
        
        return obj;
    }
    
    
    //MARK: 查询年级
    public class func getGrades(stageId: Int, subjectId:String) -> TestCenterNetwork {
        
        let obj = TestCenterNetwork.init();
        obj.dy_baseURL = self.hostUrl;
        obj.dy_requestUrl = "\(self.relativeUrl)/resource/grades";
        obj.dy_requestArgument = [
            "userId": self.userId,
            "token" : self.token,
            "stageId": stageId,
            "subjectId": subjectId,

        ];
        obj.dy_requestMethod = .GET;
        obj.dy_requestSerializerType = .JSON;
        obj.dy_responseSerializerType = .JSON;
        
        return obj;
    }
    
    //MARK: 查询版本
    public class func getVersions(subjectid: Int) -> TestCenterNetwork {
        
        let obj = TestCenterNetwork.init();
        obj.dy_baseURL = self.hostUrl;
        obj.dy_requestUrl = "\(self.relativeUrl)/resource/versions";
        obj.dy_requestArgument = [
            "userId": self.userId,
            "token" : self.token,
            "subjectId": subjectid,
        ];
        obj.dy_requestMethod = .GET;
        obj.dy_requestSerializerType = .JSON;
        obj.dy_responseSerializerType = .JSON;
        
        return obj;
    }

    //MARK: 查看答题结果
    public class func getTestResult(answers: [[String : String]]) -> TestCenterNetwork {
        
        let obj = TestCenterNetwork.init();
        obj.dy_baseURL = self.hostUrl;
        obj.dy_requestUrl = "\(self.relativeUrl)/topic/queryAnasisly";
        obj.dy_requestArgument = [
            "userId": self.userId,
            "token" : self.token,
            "answers": answers,
        ];
        obj.dy_requestMethod = .POST;
        obj.dy_requestSerializerType = .JSON;
        obj.dy_responseSerializerType = .JSON;
        
        return obj;
    }


    //MARK:收藏题目 知识点 不需要传 节点id
    public class func collectQuestion(type: Int,gradeId: Int, subjectId: String,questionId: Int,likeOrUnlike: Int,nodeId: String?) -> TestCenterNetwork {

        let obj = TestCenterNetwork.init();
        obj.dy_baseURL = self.hostUrl;
        obj.dy_requestUrl = "\(self.relativeUrl)/afterWork/like-question";
        if type == 1 {
            //章节题目收藏
            obj.dy_requestArgument = [
                "userId": self.userId,
                "token" : self.token,
                "questionId":questionId,
                "likeOrUnlike": likeOrUnlike == 1 ? 0 : 1,
                "id": nodeId ?? ""
            ];
        } else if type == 0 {
            //知识点题收藏
            obj.dy_requestArgument = [
                "userId": self.userId,
                "token" : self.token,
                "questionId":questionId,
                "likeOrUnlike": likeOrUnlike == 1 ? 0 : 1,
                "gradeId":gradeId,
                "subjectId":subjectId,
            ];
        }
        
        
        obj.dy_requestMethod = .POST;
        obj.dy_requestSerializerType = .JSON;
        obj.dy_responseSerializerType = .JSON;
        
        
        return obj;
    }
    
    
    
}
