//
//  YZDTestResultVC.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/7/14.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit

/**
 答题结果
 */
class YZDTestResultVC: UIViewController {

    
    public var recordModel: YZDTestRecordCellModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "答题结果";
        self.setupSubview();
        // Do any additional setup after loading the view.
    }
    
    private func setupSubview() {
        
        self.view.addSubview(self.tableView);
        self.tableView.backgroundColor = .HWColorWithHexString(hex: "#F7F7F7");
        self.tableView.mas_makeConstraints { (make) in
            make?.edges.offset()(0);
        }
        
        let header = YZDTestResultHeader.init(frame: .init(x: 0, y: 0, width: self.view.width, height: 400));
        
        header.didSelectedCell = {
            [weak self] (index) in
            if (self?.tableView.numberOfSections ?? 0) - 1 <= index {
                self?.tableView.scrollToRow(at: IndexPath.init(row: index, section: 0), at: .top, animated: true);
            }
        }
        
        self.tableView.tableHeaderView = header;
        self.tableView.loadDataCallback = {
            [weak self] (page, result) in
            
            self?.loadData(page: Int(page), result: result)
        }
        self.tableView.didSelectedTableViewCellCallback = {
            [weak self] (cell, indexPath) in
            
            self?.didSelectedTableViewCell(cell: cell as! YZDTestResultCell, index: indexPath)
        }
        self.tableView.begainRefreshData();
    }
    
    
    private func loadData(page: Int, result:DYTableView_Result) {
        
        
        if let _model = self.recordModel {
            YZDHomeworkNetwork.getMyHistoryHomeworkDetail(homeworkId: _model.dy_afterWorkId ?? 0, finishedHomeworkId: _model.dy_afterWorkFinishId ?? 0).dy_startRequest { (response, error) in
                
                if let _response = response as? [String : Any] {
                    
                    
                    
                } else {
                    
                    
                }
                
            }
        }
        
    }
    
    private func didSelectedTableViewCell(cell: YZDTestResultCell, index: IndexPath) {
        
        
        
    }
    
    
    private lazy var tableView: DYTableView = {
        
        let view = DYTableView.init(frame: .zero);
        view.rowHeight = 120;
        view.isShowNoData = true;
        view.noDataText = "没有答题结果";
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell");
        view.separatorStyle = .none;
        view.allowsSelection = false;
        view.rowHeight = 200;
        
        return view;
        
    }()
    

}
