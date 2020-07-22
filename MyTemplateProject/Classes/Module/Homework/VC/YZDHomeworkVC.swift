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
        self.navigationController?.navigationBar.isOpaque = false;
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
        rightBtn.titleLabel?.font = .systemFont(ofSize: 14);
        rightBtn.setTitle("答题记录", for: .normal);
        rightBtn.addTarget(self, action: #selector(rightBarButtonClick), for: .touchUpInside);
//        rightBtn.setImage(UIImage.init(named: "yzd-homework-right-btn"), for: .normal);
        rightBtn.setTitleColor(.init(hexString: "#FC952C"), for: .normal)
//        rightBtn.margin = 8
//        rightBtn.bounds = CGRect.init(x: 0, y: 0, width: 94, height: 25);
//        rightBtn.addRound(12.5);
//        rightBtn.backgroundColor = .init(hexString: "#FFF3E4");
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn);
        
    }
    
    @objc
    private func rightBarButtonClick() {
        
        let vc = YZDTestRecordVC.init()
            
        self.navigationController?.pushViewController(vc, animated: true);
        
    }
    
    private func loadData(page: Int, result:@escaping DYTableView_Result) {
        
        YZDHomeworkNetwork.getMyHomework(page: page, pageSize: 10).dy_startRequest { (response, error) in
            if let _value = response as? [String : Any],let datas = _value["list"] as? [[String : Any]] {
                var arrays:[YZDHomeworkModel] = [];
                for item in datas {
                    let model = YZDHomeworkModel.initModel(dict: item);
                    arrays.append(model);
                }
                result(arrays);
            } else {
                DYNetworkHUD.showInfo(message: error?.errorMessage ?? "没有相关数据", inView: nil);
                result([]);
            }
        }
        
    }
    
    private func didSelectedTableViewCell(cell: YZDHomeworkCell, index: IndexPath) {
        
        let vc = YZDHomeworkDetailVC.init();
        if let value = self.tableView.dy_dataSource[index.row] as? YZDHomeworkModel {
            vc.homeworkModel = value;
        }
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
        view.pageIndex = 0;
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
