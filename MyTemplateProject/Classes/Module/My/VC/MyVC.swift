//
//  MyVC.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/7/10.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit

class MyVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的";

        self.edgesForExtendedLayout = UIRectEdge.init();
        
        self.view.addSubview(self.versionLabel);
        self.versionLabel.mas_makeConstraints { (make) in
            make?.centerX.offset();
            make?.bottom.offset()(-20);
        }
        // Do any additional setup after loading the view.
    }

    private lazy var versionLabel: UILabel = {
           
           let view = UILabel.init();
           view.textColor = UIColor.lightGray;
           view.font = .boldSystemFont(ofSize: 16);
        let versionContent = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String;
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String;
        view.text = "版本号：\(versionContent ?? "")( \(buildNumber ?? "") )";
        view.numberOfLines = 2;
        view.sizeToFit();
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
