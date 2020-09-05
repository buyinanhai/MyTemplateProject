//
//  TestCenterResultVC.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/9/2.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit
import DYTemplate

/**
  练习中心答题结果
 */
class TestCenterResultVC: YZDTestResultVC {
    
    public var headerModel: YZDTestResultDetailInfo?
    public var answers: [[String : String]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
        // Do any additional setup after loading the view.
    }

    
    
    override func loadData() {
        
        
        TestCenterNetwork.getTestResult(answers: self.answers ?? []).dy_startRequest { (response, error) in
            
            self.tableView.mj_header?.endRefreshing();
            if let data = response as? [String : Any] {
                
                var results:[Int: String] = [:];
                
                if let items = data["questions"] as? [[String : Any]] {
                    
                    self.allTests = items;
                    
                    let average = 100.0 / Float(self.allTests.count);
                    var accuracy: Float = 0.0;
                    for (index,item) in items.enumerated() {
                        if let rightFlag = item["rightFlag"] as? Int {
                            
                            results[index] = "\(rightFlag)";
                            if rightFlag == 1 {
                                accuracy += average;
                            }
                        } else {
                            results[index] = "-1";
                        }
                    }
                    self.headerModel?.dy_accuracy = String.init(format: "%.2f", accuracy);
                    self.reloadWebViewContent();
                }
                
                if let model = self.headerModel {
                    self.updateHeaderView(model, results: results);
                }
                
            } else {
                if let model = self.headerModel {
                    self.updateHeaderView(model, results: [:]);
                }
                DYNetworkHUD.showInfo(message: "获取失败！", inView: self.view);
            }
            
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

}
