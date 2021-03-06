//
//  YZDTestRecordVC.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/7/13.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit

/**
 答题记录控制器
 */
class YZDTestRecordVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "答题记录";
        self.setupSubview();
        // Do any additional setup after loading the view.
    }
    
    private func setupSubview() {
        
        self.view.addSubview(self.tableView);
        self.tableView.mas_makeConstraints { (make) in
            make?.edges.offset();
        }
        self.tableView.loadDataCallback = {
            [weak self] (page, result) in
            self?.loadData(Int(page), result: result);
        }
        
        self.tableView.didSelectedTableViewCellCallback = {
            [weak self] (cell, index) in
            self?.didSelectedCell(cell, indexPath: index)
        }
        
        self.tableView.begainRefreshData();
        self.searchHeader.addTarget(self, selector: #selector(showSearchVC));

    }
    
    
    private func loadData(_ page: Int, result:@escaping DYTableView_Result) {
        
        YZDHomeworkNetwork.getMyHistoryHomework().dy_startRequest { (response, error) in
            
            if let items = response as? [[String : Any]] {
                
                var array:[YZDTestRecordCellModel] = [];
                for item in items {
                   
                    if  let model = YZDTestRecordCellModel.init(JSON: item) {
                        array.append(model);
                    }
                }
                result(array);
                
            } else {
                DYNetworkHUD.showInfo(message: error?.errorMessage ?? "没有相关数据", inView: nil);
                result([]);
            }
            
            
        }
        
        
    }
    
    private func didSelectedCell(_ cell: UITableViewCell, indexPath: IndexPath) {
        
        let vc = YZDTestResultVC.init();
        vc.recordModel = self.tableView.dy_dataSource[indexPath.row] as? YZDTestRecordCellModel;
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    

    private lazy var tableView: DYTableView = {
          
          let view = DYTableView.init(frame: .zero);
          view.rowHeight = 120;
          view.isShowNoData = true;
          view.noDataText = "没有答题记录";
          view.register(YZDTestRecordCell.self, forCellReuseIdentifier: "cell");
          view.separatorStyle = .none;
          self.searchHeader.frame = CGRect.init(x: 0, y: 0, width: self.view.width, height: 63)
          view.tableHeaderView = self.searchHeader;
          view.backgroundColor = UIColor.HWColorWithHexString(hex: "#F7F7F7")

          return view;
          
      }()

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
        searchVC.tableView?.register(YZDTestRecordCell.self, forCellReuseIdentifier: "cell");
        searchVC.tableView?.backgroundColor = UIColor.white;
        searchVC.tableView?.noDataText = "无结果"
        searchVC.tableView?.rowHeight = 120;
        searchVC.placeholdertext = "请输入课程名称";
        searchVC.selectedSearchBtnCallback = {
            (view, text) in
            view?.loadDataCallback = {
                [weak self] (pageIndex, result) in
                
                let resultDatas = self?.tableView.dy_dataSource.filter({ (value) -> Bool in
                    
                    if let _value = value as? YZDTestRecordCellModel {
                        if (_value.dy_classTypeName ?? "").contains(text) {
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
                let vc = YZDTestResultVC.init();
                vc.recordModel = self?.tableView.dy_dataSource[index.row] as? YZDTestRecordCellModel;
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


