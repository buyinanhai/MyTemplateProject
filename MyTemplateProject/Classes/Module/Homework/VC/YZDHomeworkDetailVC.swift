//
//  YZDHomeworkDetailVC.swift
//  FXFSOnlineEdu
//
//  Created by 汪宁 on 2020/7/9.
//  Copyright © 2020 fwang. All rights reserved.
//

import UIKit


//MARK: 选择作业vc
class YZDHomeworkDetailVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "选择作业";
        
        self.setupSubview();
        // Do any additional setup after loading the view.
    }
    
    
    private func setupSubview() {
        
        self.view.addSubview(self.tableView)
        self.tableView.mas_makeConstraints { (make) in
            make?.edges.offset();
        }
        let header = YZDHomeworkDetailHeaderView.initHeaderView();
        header.frame = CGRect.init(x: 0, y: 0, width: self.view.width, height: 166);
        self.tableView.tableHeaderView = header;
        
        
    }
    
    
    
    private lazy var tableView: UITableView = {
        
        let view = UITableView.init()
        
        return view;
    }()
    

}
