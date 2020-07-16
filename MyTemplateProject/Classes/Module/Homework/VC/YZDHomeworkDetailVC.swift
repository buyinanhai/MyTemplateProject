//
//  YZDHomeworkDetailVC.swift
//  FXFSOnlineEdu
//
//  Created by 汪宁 on 2020/7/9.
//  Copyright © 2020 fwang. All rights reserved.
//

import UIKit


/**
 选择作业控制器
 */
class YZDHomeworkDetailVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "选择作业";
        
        self.setupSubview();
        // Do any additional setup after loading the view.
    }
    
    
    private func setupSubview() {
        
        self.view.backgroundColor = UIColor.HWColorWithHexString(hex: "#F7F7F7")
        self.view.addSubview(self.tableView)
        self.tableView.mas_makeConstraints { (make) in
            make?.edges.offset();
        }
        let header = YZDHomeworkDetailHeaderView.initHeaderView();
        self.tableView.tableHeaderView = header;
        header.frame = CGRect.init(x: 0, y: 0, width: self.view.width, height: 90);
        self.tableView.register(YZDHomeworkDetailCell.self, forCellReuseIdentifier: "cell");
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "header");
        self.tableView.backgroundColor = .clear;
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "错题集", style: .plain, target: self, action: #selector(rightBarButtonClick));
    }
    @objc
    private func rightBarButtonClick() {
        
        let vc = YZDTestCollectionVC.init()
        
        self.navigationController?.pushViewController(vc, animated: true);
        
    }
    
    
    private lazy var tableView: UITableView = {
        
        let view = UITableView.init(frame: self.view.frame);
        view.backgroundColor = UIColor.HWColorWithHexString(hex: "#F7F7F7")
        view.allowsSelection = false;
        view.separatorColor = .clear;
        return view;
    }()
    private var datas:[[String: Any]] = [
        ["title":"课前练习第一节","practises":[1,2,3]],
        ["title":"课前练习第二节","practises":[1,2,]],
        ["title":"课前练习第三节","practises":[1,2,3,4]],
        ["title":"课前练习第四节","practises":[1]],
    ]
    

}

extension YZDHomeworkDetailVC: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! YZDHomeworkDetailCell;
        cell.model = self.datas[indexPath.row];
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height: CGFloat = 40;
        let model = self.datas[indexPath.row];
        if let datas = model["practises"] as? [Any] {
            for _ in datas {
                height += 75.0;
            }
        }
        return height;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView.init();
        header.backgroundColor = .clear;
        var btn: DYButton? = header.subviews.first as? DYButton;
        if btn == nil {
            btn = DYButton.init();
            btn?.backgroundColor = .clear;
            btn?.textColor = UIColor.HWColorWithHexString(hex: "#2A2B30");
            btn?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15);
            btn!.direction = 2;
            header.addSubview(btn!);
            btn!.addTarget(self, action: #selector(sectionHeaderClick(_:)), for: .touchUpInside)
            btn?.mas_makeConstraints({ (make) in
                make?.edges.offset();
            })
        }
        btn?.setTitle("第一讲  圆柱的表面积", for: .normal)
                
        return header
        
        
    }
    
    
    @objc
    private func sectionHeaderClick(_ sender: DYButton) {
        
        
        
    }
    
}
