//
//  LiveVC.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/8/18.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit

class LiveVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.view.addSubview(self.enterBtn);
        self.enterBtn.mas_makeConstraints { (make) in
            make?.center.offset();
        }
        self.enterBtn.addTarget(self, action: #selector(enterBtnClick), for: .touchUpInside);
        // Do any additional setup after loading the view.
    }
    
    @objc
    private func enterBtnClick() {
        
        
        
        
    }

    
    private lazy var enterBtn: UIButton = {
        
        let view = UIButton.init(type: .system);
        view.setTitle("进入直播间", for: .normal);
        
        return view;
    }()
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
