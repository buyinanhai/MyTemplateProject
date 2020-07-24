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

    public var homeworkModel: YZDHomeworkModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "选择作业";
        
        self.setupSubview();
        self.loadData();
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
        header.frame = CGRect.init(x: 0, y: 0, width: self.view.width, height: 105);
        self.tableView.register(YZDHomeworkDetailCell.self, forCellReuseIdentifier: "cell");
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "header");
        self.tableView.backgroundColor = .clear;
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "错题集", style: .plain, target: self, action: #selector(rightBarButtonClick));
    }
    
    
    
    private func loadData() {
        
        DYNetworkHUD.startLoading();
        //先获取章节  再获取课程作业
        YZDHomeworkNetwork.getChapterFromCourse(classTypeId: self.homeworkModel.productId ?? 0, liveOrVideo: self.homeworkModel.homeworkType).dy_startRequest { (response, error) in
            if let _response = response as? [[String : Any]] {
                
                for item in _response {
                    if  let id = item["moduleId"] as? Int, let name = item["moduleName"] as? String {
                        self.chapters.append((id, name));
                    }
                }
                self.currentChapter = self.chapters.first;
                
                if self.chapters.count > 0 {
                    self.loadHomework(self.currentChapter?.0 ?? 0);
                } else {
                    DYNetworkHUD.dismiss();
                    self.tableView.reloadData();
                }
                
            } else {
                
                DYNetworkHUD.showInfo(message: error?.errorMessage ?? "没有相关数据", inView: nil)
            }
        }
        
        
    }
    private func loadHomework(_ moduleId: Int) {
        
        YZDHomeworkNetwork.getHomeworkFromCourse(classTypeId: self.homeworkModel.productId ?? 0, liveOrVideo: self.homeworkModel.homeworkType, classModuleId: moduleId).dy_startRequest { (response, error) in
            
            DYNetworkHUD.dismiss();
            if let _response = response as? [String : Any] {
                
                if let headerDict = _response["classTypeVo"] as? [String : Any] {
                    self.updateHeaderView(dict: headerDict);
                }
                if let list = _response["moduleList"] as? [String : Any], let sections = list["classModuleLessonWorkVoList"] as? [[String : Any]] {
                    self.datas.removeAll();
                    for item in sections {
                        if let section = YZDHomeworkChapterSectionModel.init(JSON: item) {
                            self.datas.append(section);
                        }
                    }
                    self.tableView.reloadData();
                }
                
            } else {
                DYNetworkHUD.showInfo(message: error?.errorMessage ?? "没有相关数据", inView: nil)
            }
        }
        
    }
    
    private func updateHeaderView(dict: [String : Any]) {
        
        let model = YZDHomeworkDetailHeaderViewModel.modelWithDict(dict);
        
        let view = self.tableView.tableHeaderView as? YZDHomeworkDetailHeaderView;
        view?.model = model;
        
    }
    
    
    @objc
    private func rightBarButtonClick() {
        
        let vc = YZDTestCollectionVC.init()
        vc.productId = self.homeworkModel.productId;
        self.navigationController?.pushViewController(vc, animated: true);
        
    }
    
    
    private lazy var tableView: UITableView = {
        
        let view = UITableView.init(frame: self.view.frame);
        view.backgroundColor = UIColor.HWColorWithHexString(hex: "#F7F7F7")
        view.allowsSelection = true;
        view.separatorColor = .clear;
        return view;
    }()
    private var datas:[YZDHomeworkChapterSectionModel] = [
        
    ]
    
    /**
            id    name
     */
    private var chapters: [(Int, String)] = [];
    
    /**
               id    name
        */
    private var currentChapter:(Int, String)?
    private var currentChapterIndex:Int = 0;


}

extension YZDHomeworkDetailVC: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! YZDHomeworkDetailCell;
        cell.selectionStyle = .none;
        let section = self.datas[indexPath.row];
        cell.model = section;
        cell.stateBtnClickCallback = {
            [weak self] (model) in
                
            let vc = YZDTestAnswerVC.init();
            vc.afterWorkId = model?.dy_id;
            self?.navigationController?.pushViewController(vc, animated: true);
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height: CGFloat = 60;
        let model = self.datas[indexPath.row];
        height += CGFloat((model.dy_afterWorks?.count ?? 0)) * 75.0;
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
        var name = self.currentChapter?.1;
        if name?.length ?? 0 > 0 {
            name = name! + "  ▼";
        }
        btn?.setTitle(name, for: .normal);
                
        return header
        
        
    }
    
    
    
    
    @objc
    private func sectionHeaderClick(_ sender: DYButton) {
        
        let view = DYSinglePickerView.init();
        view.title = "选择单元";
        view.sources = self.chapters.map({ (value) -> String in
            return value.1;
        })
        view.defalutIndex = self.currentChapterIndex
    
        view.selectResult = {
            [weak self] (value) in

            
            if let model = self?.chapters[Int(value)] {
                
                self?.loadHomework(model.0);
                self?.currentChapter = model;
                self?.currentChapterIndex = Int(value);
            }
            
            
        }
        view.show();
        
        
    }
    
}
