//
//  TestCenterAnswerVC.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/8/13.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit
import DYTemplate.DYNetwork

class TestCenterAnswerVC: YZDTestAnswerVC {

    public var knowledgeId: String?
    
    public var chapterId: String?;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "答题";
        self.headerView.hideTimeView();
        // Do any additional setup after loading the view.
    }
    
   
    
    override var isEnableClickNoAnswer: Bool {
        
        get {
            return false;
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc
    override func showResultVC() {
      
        let vc = TestCenterResultVC.init();
        vc.answers = self.answers;
        let model = YZDTestResultDetailInfo.init(JSON: [:]);
        model?.dy_title = self.knowledgeId == nil ? "按章节出题" : "按知识点出题";
        model?.dy_finishCount = self.answers?.count;
        model?.dy_usedTime = self.headerView.getUsedTime();
        vc.headerModel = model;
        self.navigationController?.pushViewController(vc, animated: true);
    }
    internal var answers: [[String : String]]?
    
    
    deinit {
           print("TestCenterAnswerVC 8888")
    }
}


extension TestCenterAnswerVC {
    
    
    
    override func loadData() {
        
        DYNetworkHUD.startLoading();
        if let id = self.knowledgeId {
            TestCenterNetwork.getRandomTests(byKnowledge: id, questionCount: 5).dy_startRequest { (response, error) in

                DYNetworkHUD.dismiss();
                if let _response = response as? [String : Any] {
                    
                    if let items = _response["questions"] as? [[String : Any]] {
                      
                        self.show(questions: items);
                    }
                    
                } else {
                    
                    DYNetworkHUD.showInfo(message: error?.errorMessage ?? "没有相关试题", inView: nil);
                }
            };
        }
        
        if let id = self.chapterId {
            
            TestCenterNetwork.getRandomTests(byDirectory: id, questionCount: 5).dy_startRequest { (response, error) in
                
                DYNetworkHUD.dismiss();
                if let _response = response as? [String : Any] {
                    
                    if let items = _response["questions"] as? [[String : Any]] {
                        
                        self.show(questions: items);

                    }
                    
                } else {
                    
                    DYNetworkHUD.showInfo(message: error?.errorMessage ?? "没有相关试题", inView: nil);
                }
            }
        }
    }
    
    override func commitAnswer(answers: [[String : String]]) {
        
        DYNetworkHUD.startLoading()
        TestCenterNetwork.commitAnswers(answers: answers).dy_startRequest { (response, error) in
            
            if error != nil {
                
                DYNetworkHUD.showInfo(message: error?.errorMessage ?? "提交失败!", inView: nil);
            } else {
                
                self.updateRightBarButton(true);
                self.answers = answers;
                DYNetworkHUD.showInfo(message: "提交成功!", inView: nil);
                
            }
        }
    }
    
}
