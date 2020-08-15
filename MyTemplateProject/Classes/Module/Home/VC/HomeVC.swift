//
//  HomeVC.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/7/10.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit

/**
 首页控制器
 */
class HomeVC: UIViewController {
    
     override func viewDidLoad() {
        
         super.viewDidLoad()
        self.title = "首页";
        
        self.view.addSubview(self.tableView);
        self.tableView.mas_makeConstraints { (make) in
            make?.edges.offset()
        }
         self.tableView.delegate  = self;
         self.tableView.dataSource = self;
         self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
         // Do any additional setup after loading the view.
     }
     
     private var datas: [String] = [
     
         "优智多课堂作业中心",
         "测试wkwebview",
         "练习中心"
         
     ];
    
    
    private lazy var tableView: UITableView = {
        
        let view = UITableView.init()
        return view;
    }()

}


extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        cell.textLabel?.text = self.datas[indexPath.row];
        cell.accessoryType = .disclosureIndicator;
        return cell;
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var vc: UIViewController?;
        
        switch indexPath.row {
        case 0:
            vc = YZDHomeworkVC.init();
            break
        case 1:
            vc = TestWebViewVC.init();
            break;
        case 2:
            vc = TestCenterChooseVC.init();
            break;
        default:
            break
        }

        if  let _vc = vc  {
            vc?.hidesBottomBarWhenPushed = true;
            self.navigationController?.pushViewController(_vc, animated: true);
        }
        
    }
    
    
    
}
