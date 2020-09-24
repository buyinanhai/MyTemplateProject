//
//  YZDHomeworkModel.swift
//  FXFSOnlineEdu
//
//  Created by 汪宁 on 2020/7/9.
//  Copyright © 2020 fwang. All rights reserved.
//

import UIKit

public class YZDHomeworkModel: NSObject {

    public var homeworkName: String!
    public var icon: String?
    public var topicCount: Int!
    public var accuracy: String?
    public var finishedCount: Int?
    public var productId: Int!
    
    public var liveFlag: Int?
    public var videoFlag: Int?
    
    
    public var homeworkType: String {
        
        
        get {
            var type: String?
            
            if self.liveFlag == 0 && self.videoFlag == 1 {
                type = "video"
            } else if self.liveFlag == 1 && self.videoFlag == 0 {
                type = "live";
            } else if self.liveFlag == 1 && self.videoFlag == 1 {
                
                type = "blend";
            }
            
            return type ?? ""
        }
        
    }
    /*
     finishCount":9,                //类型：Number  必有字段  备注：完成题目数量
     "accuracy":"66.7",                //类型：String  必有字段  备注：正确率
     "questionCount":28,
     */
    class func initModel(dict: [String : Any]) -> YZDHomeworkModel {
        
        let obj = YZDHomeworkModel.init()
        obj.homeworkName = dict["name"] as? String ?? ""
        obj.icon = dict["coverUrl"] as? String ?? ""
        obj.finishedCount = dict["finishCount"] as? Int ?? 0;
        obj.accuracy = dict["accuracy"] as? String;
        obj.topicCount = dict["questionCount"] as? Int ?? 0;
        obj.productId = dict["productId"] as? Int ?? 0;
        obj.liveFlag = dict["liveFlag"] as? Int
        obj.videoFlag = dict["videoFlag"] as? Int
        return obj;
    }
    
    
    
}
