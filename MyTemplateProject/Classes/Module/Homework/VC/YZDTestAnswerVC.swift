//
//  YZDTestAnswerVC.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/7/14.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit


/**
 答题
 */
class YZDTestAnswerVC: UIViewController {

    
    public var afterWorkId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "答题";
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "提交", style: .plain, target: self, action: #selector(rightBatButtonClick));
        // Do any additional setup after loading the view.
    }
    
    @objc
    private func rightBatButtonClick() {
        
        
        
        
        
        
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
