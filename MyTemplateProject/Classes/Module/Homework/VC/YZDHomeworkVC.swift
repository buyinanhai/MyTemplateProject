//
//  YZDHomeworkVC.swift
//  FXFSOnlineEdu
//
//  Created by 汪宁 on 2020/7/9.
//  Copyright © 2020 fwang. All rights reserved.
//

import UIKit

/**
 作业中心控制器
 */
class YZDHomeworkVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "作业中心"
        self.setupSubview();
        self.tableView.begainRefreshData();
        self.navigationController?.navigationBar.backgroundColor = kDY_ThemeColor;
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
        rightBtn.setTitle("答题记录", for: .normal);
        rightBtn.addTarget(self, action: #selector(rightBarButtonClick), for: .touchUpInside);
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn);
        
    }
    
    @objc
    private func rightBarButtonClick() {
        
        let vc = YZDTestRecordVC.init()
            
        self.navigationController?.pushViewController(vc, animated: true);
        
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
        self.searchBar.frame = CGRect.init(x: 0, y: 0, width: self.view.width, height: 55)
        view.tableHeaderView = self.searchBar;
        
        return view;
        
    }()
    
    private lazy var searchBar: UISearchBar = {
        
        let bar = UISearchBar.init()
        bar.placeholder = "请输入课程名称";
        bar.barStyle = .default;
        bar.backgroundColor = .gray;
        bar.delegate = self;
        return bar;
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


extension YZDHomeworkVC: UISearchBarDelegate {
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true);
        self.showSearchVC();
    }
    
    
    private func showSearchVC() {
        
        let vc = DYSearchVC.searchVC();
        
        
        self.present(vc, animated: true, completion: nil);
        
    }
    
}
