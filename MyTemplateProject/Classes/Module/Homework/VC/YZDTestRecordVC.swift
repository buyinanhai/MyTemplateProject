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
        
    }
    
    
    private func loadData(_ page: Int, result: DYTableView_Result) {
        
        result([1,2,3,4,3,3,3,3,3]);
        
    }
    
    private func didSelectedCell(_ cell: UITableViewCell, indexPath: IndexPath) {
        
        let vc = YZDTestResultVC.init();
        
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    

    private lazy var tableView: DYTableView = {
          
          let view = DYTableView.init(frame: .zero);
          view.rowHeight = 120;
          view.isShowNoData = true;
          view.noDataText = "没有错题集";
          view.register(YZDTestRecordCell.self, forCellReuseIdentifier: "cell");
          view.separatorStyle = .none;
          self.searchBar.frame = CGRect.init(x: 0, y: 0, width: self.view.width, height: 55)
          view.tableHeaderView = self.searchBar;
          view.backgroundColor = UIColor.HWColorWithHexString(hex: "#F7F7F7")

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
extension YZDTestRecordVC: UISearchBarDelegate {
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true);
        self.showSearchVC();
    }
    
    
    private func showSearchVC() {
        
        let vc = DYSearchVC.searchVC();
        
        
        self.present(vc, animated: true, completion: nil);
        
    }
    
}
