//
//  DYBaseNavigationVC.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/8/12.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit

class DYBaseNavigationVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        super.loadView();
        
        let navBar = UINavigationBar.appearance();
        navBar.backgroundColor = .white;
        // 1.1 设置导航条字体
        var dict:[NSAttributedString.Key : Any] = [:]
        
        dict.updateValue(UIFont.boldSystemFont(ofSize: 17), forKey: NSAttributedString.Key.font);
        navBar.titleTextAttributes = dict;
           // 1.2 设置导航条背景图片
        navBar.setBackgroundImage(UIImage.init(named: ""), for: .default);
           // 1.3 设置导航栏分割线为透明
        navBar.shadowImage = UIImage.init();
           // 2. 获取所有导航控制器的item实例
        let barBtn = UIBarButtonItem.appearance();
           // 2.1 设置barButton的文字普通状态下的属性
        var barBtnAttributesN: [NSAttributedString.Key : Any] = [:];
        barBtnAttributesN.updateValue(UIColor.orange, forKey: .foregroundColor);
        barBtnAttributesN.updateValue(UIFont.systemFont(ofSize: 15), forKey: NSAttributedString.Key.font);
               // 设置普通状态
        barBtn.setTitleTextAttributes(barBtnAttributesN, for: .normal);
           // 2.2 设置barButton的文字不可用状态下的属性
        var barBtnAttributesS: [NSAttributedString.Key : Any] = [:];
        barBtnAttributesS.updateValue(UIColor.lightGray, forKey: .foregroundColor);
        barBtnAttributesS.updateValue(UIFont.systemFont(ofSize: 15), forKey: NSAttributedString.Key.font);
        // 设置不可用状态
        barBtn.setTitleTextAttributes(barBtnAttributesS, for: .disabled);
    }
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        // 当不是根控制器时
        if (self.viewControllers.count > 0) {
            // 隐藏tabBar
            viewController.hidesBottomBarWhenPushed = true;
            // 自定义导航栏左边按钮
            let btn = UIButton.init(type: .custom);
            btn.setImage(UIImage.init(named: "nav-back"), for: .normal);
            btn.setImage(UIImage.init(named: "nav-back"), for: .highlighted);
            btn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
            btn.bounds = CGRect.init(x: 0, y: 0, width: 35, height: 35);
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: btn);
        }
        super.pushViewController(viewController, animated: animated);
    }
    
    @objc
    private func backBtnClick() {
        self.popViewController(animated: true);
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
