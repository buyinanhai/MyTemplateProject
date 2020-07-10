//
//  YZDHomeworkVC.swift
//  FXFSOnlineEdu
//
//  Created by 汪宁 on 2020/7/9.
//  Copyright © 2020 fwang. All rights reserved.
//

import UIKit

class YZDHomeworkVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "作业中心"
        self.setupSubview();
        self.tableView.begainRefreshData();
        // Do any additional setup after loading the view.
    }
    
    
    private func setupSubview() {
        
        self.view.addSubview(self.tableView);
        
        self.tableView.mas_makeConstraints { (make) in
            make?.edges.offset();
        }
        self.tableView.loadDataCallback = {
            [weak self] (page, result) in
            
            self?.loadData(page: Int(page), result: result)
        }
        self.tableView.didSelectedTableViewCellCallback = {
            [weak self] (cell, indexPath) in
            
            self?.didSelectedTableViewCell(cell: cell as! YZDHomeworkCell, index: indexPath)
        }
        self.tableView.backgroundColor = .HWColorWithHexString(hex: "#F7F7F7");
        
        let rightBtn = DYButton.init(type: .custom);
        rightBtn.direction = 1;
        rightBtn.setTitle("datijil", for: .normal);
        rightBtn.addTarget(self, action: #selector(rightBarButtonClick), for: .touchUpInside);
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn);
        
    }
    
    @objc
    private func rightBarButtonClick() {
        
            
        
    }
    
    private func loadData(page: Int, result:DYTableView_Result) {
        
        var datas:[YZDHomeworkModel] = [];
        
        for index in 0..<3 {
            
            let model = YZDHomeworkModel.init();
            model.homeworkName = "作业名称\(index + 1)";
            model.topicCount = "\(index + 10)";
            model.accuracy = "\(CGFloat(99.0 / CGFloat(index)))";
            datas.append(model);
        }
        result(datas);
        
    }
    
    private func didSelectedTableViewCell(cell: YZDHomeworkCell, index: IndexPath) {
        
        let vc = YZDHomeworkDetailVC.init();
        
        self.navigationController?.pushViewController(vc, animated: true);
        
        
    }

    
    private lazy var tableView: DYTableView = {
        
        let view = DYTableView.init(frame: .zero);
        view.rowHeight = 120;
        view.isShowNoData = true;
        view.noDataText = "没有作业内容";
        view.register(YZDHomeworkCell.self, forCellReuseIdentifier: "cell");
        view.separatorStyle = .none;
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
