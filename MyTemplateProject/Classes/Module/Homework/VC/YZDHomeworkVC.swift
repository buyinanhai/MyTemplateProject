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
        
        self.searchHeader.addTarget(self, selector: #selector(showSearchVC));
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
        self.searchHeader.frame = CGRect.init(x: 0, y: 0, width: self.view.width, height: 63)
        view.tableHeaderView = self.searchHeader;
        view.pageIndex = 0;
        view.pageSize = 10;
        return view;
        
    }()
//
//    private lazy var searchBar: UISearchBar = {
//
//        let bar = UISearchBar.init()
//        bar.placeholder = "请输入课程名称";
//        bar.barStyle = .default;
//        bar.backgroundColor = .gray;
//        bar.delegate = self;
//        bar.searchBarStyle = .minimal
//        return bar;
//    }()
    
    private lazy var searchHeader: UIView = {
        
        let view = UIView.init();
        view.backgroundColor = .clear;
        
        let placeView = UILabel.init();
        placeView.backgroundColor = UIColor.white;
        placeView.addRound(10);
        placeView.text = "   请输入课程名称";
        placeView.textColor = .init(hexString: "#BBBBBB")
        placeView.font = .systemFont(ofSize: 13);
        view.addSubview(placeView);
        
        let searchBtn = UIButton.init();
        searchBtn.setImage(UIImage.init(named: "yzd-homework-search"), for: .normal);
        searchBtn.isUserInteractionEnabled = false;
        searchBtn.setBackgroundImage(UIImage.init(named: "yzd-homework-search-bg"), for: .normal);
        view.addSubview(searchBtn);
        searchBtn.mas_makeConstraints { (make) in
            make?.right.offset()(-15);
            make?.left.equalTo()(placeView.mas_right);
            make?.width.offset()(49);
            make?.height.offset()(33);
            make?.top.offset()(15);
        }
        placeView.mas_makeConstraints { (make) in
            make?.left.top()?.offset()(15);
            make?.right.equalTo()(searchBtn.mas_left)?.offset()(10);
            make?.height.offset()(33);
        }
        
        
        return view;
    }()
    
    @objc
    private func showSearchVC() {
        
        let searchVC = DYSearchVC.searchVC();
        searchVC.resultVCBackgroundColor = .init(hexString: "#F7F7F7");
        searchVC.tableView?.register(YZDHomeworkCell.self, forCellReuseIdentifier: "cell");
        searchVC.tableView?.backgroundColor = UIColor.white;
        searchVC.tableView?.noDataText = "无结果"
        searchVC.tableView?.rowHeight = 120;
        searchVC.placeholdertext = "请输入课程名称";
        searchVC.selectedSearchBtnCallback = {
            (view, text) in
            view?.loadDataCallback = {
                [weak self] (pageIndex, result) in
                
                let resultDatas = self?.tableView.dy_dataSource.filter({ (value) -> Bool in
                    
                    if let _value = value as? YZDHomeworkModel {
                        if _value.homeworkName.contains(text) {
                            return true;
                        } else {
                            return false;
                        }
                    }
                    return false;
                });
                result(resultDatas ?? []);
            }
            view?.begainRefreshData();
        }
        searchVC.tableView?.didSelectedTableViewCellCallback = {
            [weak self] (cell, index) in
            self?.dismiss(animated: true, completion: {
                let vc = YZDHomeworkDetailVC.init();
                vc.homeworkModel = cell.model as? YZDHomeworkModel;
                self?.navigationController?.pushViewController(vc, animated: true);
            })
        }
        searchVC.tableView?.backgroundColor = UIColor.clear;
        searchVC.tableView?.separatorColor = .clear
        searchVC.tableView?.isShowNoData = false;
        
        self.present(searchVC, animated: true, completion: nil);
        
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
