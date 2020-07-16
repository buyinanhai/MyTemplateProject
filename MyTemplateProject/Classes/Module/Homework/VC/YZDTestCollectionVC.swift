//
//  YZDTestCollectionVC.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/7/14.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit
/**
 错题集
 */
class YZDTestCollectionVC: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "错题集";
        self.setupSubview();
        // Do any additional setup after loading the view.
    }
    
    
    
    private func setupSubview() {
        
        self.edgesForExtendedLayout = UIRectEdge.init();
        
        self.view.addSubview(self.sliderView);
        self.sliderView.mas_makeConstraints { (make) in
            make?.left.right()?.top()?.offset();
            make?.height.offset()(self.headerHeight);
        }
        self.view.addSubview(self.tableView);
        self.tableView.backgroundColor = .HWColorWithHexString(hex: "#F7F7F7");
        self.tableView.mas_makeConstraints { (make) in
            make?.left.right()?.bottom()?.offset()(0);
            make?.top.offset()(self.headerHeight);
        }
        self.tableView.loadDataCallback = {
            [weak self] (page, result) in
            
            self?.loadData(page: Int(page), result: result)
        }
        self.tableView.didSelectedTableViewCellCallback = {
            [weak self] (cell, indexPath) in
            
            self?.didSelectedTableViewCell(cell: cell as! YZDTestResultCell, index: indexPath)
        }
        self.tableView.begainRefreshData();
        self.model = nil;
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "编辑", style: .plain, target: self, action: #selector(rightBarButtonClick));

    }
    
    @objc
    private func rightBarButtonClick() {
        
        
        
    }
    
    
    private func loadData(page: Int, result:DYTableView_Result) {
        
        
        result([1,2,2,3,3,1,2,2,3,3,1,2,2,3,3,1,2,2,3,3,]);
        
    }
    
    private func didSelectedTableViewCell(cell: YZDTestResultCell, index: IndexPath) {
        
        
        
        
    }
    
    
    private lazy var tableView: DYTableView = {
        
        let view = DYTableView.init(frame: .zero);
        view.rowHeight = 120;
        view.isShowNoData = true;
        view.noDataText = "没有错题集";
        view.register(YZDTestResultCell.self, forCellReuseIdentifier: "cell");
        view.separatorStyle = .none;
        view.allowsSelection = false;
        view.rowHeight = 200;
        
        return view;
        
    }()
    
    private var sliderView: DYSliderHeadView = {
        
        let view = DYSliderHeadView.init(titles: []);
        view.selectColor = kDY_ThemeColor;
        view.sliderLineWidth = 12;
        
        return view;
        
    }()
    
    private var headerHeight: CGFloat {
        
        get {
            
            return 44.0;
            
        }
    }

    private var model: Any? {
        
        didSet {
            
            self.sliderView.updateTitles(["语文","语文1","语文3","语文4"]);
                      
            
        }
        
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
