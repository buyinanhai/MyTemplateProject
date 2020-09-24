//
//  TestCenterHomeVC.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/8/7.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit
import MJRefresh
import DYTemplate.DYNetwork

class TestCenterHomeVC: UIViewController {

    //科目id
    public var subjectId: Int = -1
    //册别id
    public var volumeId: Int = -1
    
    public var headerTitle: String?
    public var subjectTitle: String?
    
    public var chooseVC: TestCenterChooseVC!
    
    public var gradeId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "练习中心"
        if self.chooseVC == nil {
            self.chooseVC = TestCenterChooseVC.init();
        }
        if let dict = TestCenterChooseVC.getLocalData(), let model = TestCenterLocalChooseModel.init(JSON: dict) {
           
            self.subjectId = model.subjectId;
            self.volumeId = model.volumeId;
            self.headerTitle = model.headerTitle;
            self.subjectTitle = model.subjectTitle;
            self.gradeId = model.gradeId;
        }
        self.setupSubView();
        self.tableView.mj_header?.beginRefreshing();
        
        self.loadData()
        // Do any additional setup after loading the view.
    }
    
    private func setupSubView() {
        self.view.backgroundColor = .init(hexString: "#F7F7F7");
        self.edgesForExtendedLayout = UIRectEdge.init();
        self.view.addSubview(self.headerView);
        self.headerView.mas_makeConstraints { (make) in
            make?.left.right()?.top()?.offset();
            make?.height.offset()(190);
        }
       self.headerView.titleLabel.text = self.headerTitle;
       self.headerView.subjectLabel.text = self.subjectTitle;
        self.headerView.delegate = self;
        self.view.addSubview(self.tableView);
        self.tableView.mas_makeConstraints { (make) in
            make?.bottom.offset()(-20);
            make?.left.offset()(15);
            make?.right.offset()(-15);
            make?.top.equalTo()(self.headerView.mas_bottom);
        }
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData));
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.addRound(5)
    
    }
    
    public func update() {
        
        self.headerView.titleLabel.text = self.headerTitle;
        self.headerView.subjectLabel.text = self.subjectTitle;
        self.tableView.mj_header?.beginRefreshing();
    }
    
    
    //MARK: network
    @objc
    private func loadData () {
        
        
        DYNetworkHUD.startLoading()
        if self.subjectId > 0 {
            TestCenterNetwork.getKnowledgePoints(from: self.subjectId).dy_startRequest { (response, error) in
                
                if let _response = response as? [String : Any], let list = _response["list"] as? [[String :Any]] {
                    
                    DYNetworkHUD.dismiss();
                    self.datas = self.handlerChapterPointsData(list: list, parent: nil);
                    self.tableView.reloadData();
                    if let totalCount = _response["totalCount"] as? Int, let finishCount = _response["finishCount"] as? Int {
                        
                        self.headerView.progressLabel.text = "已做题 \(finishCount)/\(totalCount)";
                    }
                } else {
                    DYNetworkHUD.showInfo(message: error?.errorMessage ?? "加载失败，请稍后重试", inView: self.view);
                    
                }
                self.tableView.mj_header?.endRefreshing();
            }
        } else if self.volumeId > 0 {
            
            TestCenterNetwork.getChapterPoints(fromVolume: self.volumeId).dy_startRequest { (response, error) in

                if let _response = response as? [String : Any], let list = _response["list"] as? [[String :Any]] {
                    
                    DYNetworkHUD.dismiss();
                    self.datas = self.handlerChapterPointsData(list: list,parent: nil) ;
                    self.tableView.reloadData();
                    if let totalCount = _response["totalCount"] as? Int, let finishCount = _response["finishCount"] as? Int {
                        
                        self.headerView.progressLabel.text = "已做题 \(finishCount)/\(totalCount)";
                    }
                } else {
                    DYNetworkHUD.showInfo(message: error?.errorMessage ?? "加载失败，请稍后重试", inView: self.view);
                    
                }
                self.tableView.mj_header?.endRefreshing();
            }
        }
    }
    
    private func handlerChapterPointsData(list: [[String : Any]]?, parent: TestCenterNodeModel?) -> [TestCenterNodeModel] {
                
        var results: [TestCenterNodeModel] = []
        
        var searchDatas: [TestCenterNodeModel] = [];
        for (index,item) in (list ?? []).enumerated() {
            if let node = TestCenterNodeModel.init(JSON: item) {
                
                node.dy_parent = parent;
                node.dy_level = (parent?.dy_level ?? 0) + 1;
                node.dy_children = self.handlerChapterPointsData(list: item["children"] as? [[String : Any]], parent: node);
                results.append(node);
                self.cellIndexs[node.dy_id ?? ""] = index;
            }
            if let node = TestCenterNodeModel.init(JSON: item) {
                
                node.dy_parent = parent;
                node.dy_level = (parent?.dy_level ?? 0) + 1;
                node.dy_children = self.handlerChapterPointsData(list: item["children"] as? [[String : Any]], parent: node);
                searchDatas.append(node);
            }
            
        }
        self.searchDatas = searchDatas;
        return results;
    }
    
     
    //MARK: lazy  & properties
    
    private lazy var headerView: TestCenterHeaderView = {
        
        let view = TestCenterHeaderView.init(frame: .init(x: 0, y: 0, width: self.view.width, height: 190));
        
        
        return view;
    }()
    
    
    private lazy var tableView: UITableView = {
        
        let view = UITableView.init();
        view.separatorColor = .clear;
        view.register(TestCenterChapterNodeCell.self, forCellReuseIdentifier: "cell");
        view.rowHeight = 50;
        view.allowsSelection = false;
        
        return view;
    }()
  
    private var datas: [TestCenterNodeModel] = []
    
    //模型id在列表中的索引位置
    private var cellIndexs: [String : Int] = [:]
    
    private var searchDatas: [TestCenterNodeModel] = []
    
    //模型id在列表中的索引位置
    private var searchCellIndexs: [String : Int] = [:]
    /**
     当前是否正在搜索
     */
    private var isSearching:Bool = false;
    
    private weak var searchTableView: DYTableView?
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TestCenterHomeVC: UITableViewDataSource, UITableViewDelegate, TestCenterChapterNodeCellDelegate, TestCenterHeaderViewDelegate {
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return self.datas.count;
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TestCenterChapterNodeCell;
        cell.model = self.datas[indexPath.row];
        cell.delegate = self;
        
        return cell;
    }
    
    //MARK: TestCenterChapterNodeCellDelegate
    
    internal func onClickStartBtn(model: TestCenterNodeModel) {
        self.showAnswerVC(model: model);
    }
    
    internal func onClickFolderBtn(model: TestCenterNodeModel,isSelectd: Bool) {
        
        let currentIndex = self.isSearching ? self.searchCellIndexs[model.dy_id ?? ""] : self.cellIndexs[model.dy_id ?? ""];
        var sources = self.isSearching ? (self.searchTableView?.dy_dataSource as? [TestCenterNodeModel]) : self.datas;

        
        if isSelectd {
            
            //展开
            var indexPaths:[IndexPath] = []
            
            for (index,item) in (model.dy_children ?? []).enumerated() {
                
                let newIndex = (currentIndex ?? 0) + index + 1;
                sources?.insert(item, at: newIndex);
                indexPaths.append(IndexPath.init(row: newIndex, section: 0));
            }
            if !self.isSearching {
                self.datas = sources ?? [];
                self.tableView.insertRows(at: indexPaths, with: .automatic);
            } else {
                self.searchTableView?.dy_dataSource = NSMutableArray.init(array: sources ?? []);
                self.searchTableView?.insertRows(at: indexPaths, with: .automatic)
            }
        } else {
            
            //折叠
            var indexPaths:[IndexPath] = []
            
            //获取要删除的索引，需要递归
            let willRemovesIndex = self.getCellIndexForDelete(model: model);
            for index in willRemovesIndex {
                indexPaths.append(IndexPath.init(row: index, section: 0));
            }
            sources?.removeSubrange(Range.init(NSRange.init(location: willRemovesIndex.first ?? 0, length: willRemovesIndex.count))!);
            if !self.isSearching {
                self.datas = sources ?? [];
                self.tableView.deleteRows(at: indexPaths, with: .automatic);
            } else {
                self.searchTableView?.dy_dataSource = NSMutableArray.init(array: sources ?? []);
                self.searchTableView?.deleteRows(at: indexPaths, with: .automatic);
            }
        }
        self.updateCellIndexs();

    }
    private func showAnswerVC(model: TestCenterNodeModel) {
        
        let vc = TestCenterAnswerVC.init();
        if self.subjectId > 0 {
            vc.chapterId = model.dy_id;
        } else {
            vc.knowledgeId = model.dy_id;
        }
        vc.gradeId = self.gradeId;
        vc.subjectId = "\(self.subjectId)";
        self.navigationController?.pushViewController(vc, animated: true);
        
    }
    
    /**
     递归查询要删除的索引，包含被展开的子节点索引
     */
    private func getCellIndexForDelete(model: TestCenterNodeModel) -> [Int] {
        
        var indexs:[Int] = [];
        
        var cellIndexs = self.isSearching ? self.searchCellIndexs : self.cellIndexs;
        
        for item in model.dy_children ?? []{
            
            if let value = cellIndexs[item.dy_id ?? ""] {
                indexs.append(value);
                cellIndexs.removeValue(forKey: item.dy_id ?? "");
            }
            
            //判断是否展开了，展开了才去查询子节点
            if item.dy_isUnfold {
                item.dy_isUnfold = false;
                let results = self.getCellIndexForDelete(model: item);
                indexs.append(contentsOf: results);
            }
        }
        return indexs;
    }
    
    /**
     更新索引表
     */
    private func updateCellIndexs() {
                
        let sources = self.isSearching ? self.searchTableView?.dy_dataSource as? [TestCenterNodeModel] : self.datas;

        for (index,item) in (sources ?? []).enumerated() {
            if self.isSearching {
                self.searchCellIndexs.updateValue(index, forKey: item.dy_id ?? "");
            } else {
                self.cellIndexs.updateValue(index, forKey: item.dy_id ?? "");
            }
        }
        
    }
    
    //MARK: TestCenterHeaderViewDelegate
    
    func onClickChooseBtn() {
        
        self.navigationController?.pushViewController(self.chooseVC, animated: true);        
    }
    
    func onShowSearchVC() {
        
        self.showSearchVC();
    } 
    
    
    
    @objc
    private func showSearchVC() {
        
        let searchVC = DYSearchVC.searchVC();
        searchVC.resultVCBackgroundColor = .init(hexString: "#F7F7F7");
        searchVC.tableView?.register(TestCenterChapterNodeCell.self, forCellReuseIdentifier: "cell");
        searchVC.tableView?.backgroundColor = UIColor.white;
        searchVC.tableView?.noDataText = "无结果"
        searchVC.tableView?.rowHeight = 50;
        searchVC.placeholdertext = "请输入关键词搜索知识点";
        searchVC.tableView?.allowsSelection = false;
        searchVC.selectedSearchBtnCallback = {
            (view, text) in
            view?.loadDataCallback = {
                [weak self] (pageIndex, result) in
                
                self?.search(for: text, result: result);
            }
            view?.begainRefreshData();
        }
        searchVC.tableView?.didSelectedCellSubViewCallback = {
            [weak self] (model, flag) in

            if let _model = model as? TestCenterNodeModel {
               
                if flag == 1001 {
                    //点击了展开按钮
                    self?.onClickFolderBtn(model: _model, isSelectd: _model.dy_isUnfold);
                } else if flag == 1002 {
                    //点击了开始做题
                    self?.dismiss(animated: true, completion: {
                        
                        self?.showAnswerVC(model: _model);
                        
                    })
                }
            }
        }
        searchVC.didDismissSearchControllerCallback = {
            [weak self] in
            self?.isSearching = false;
            
            self?.clearSearchResult()
            
        }
        
        searchVC.tableView?.backgroundColor = UIColor.clear;
        searchVC.tableView?.separatorColor = .clear
        searchVC.tableView?.isShowNoData = false;
        
        
        self.present(searchVC, animated: true) {
            self.isSearching = true;
            self.searchTableView = searchVC.tableView;
        }
        
    }
    
    private func clearSearchResult() {
        for item in (self.searchTableView?.dy_dataSource as? [TestCenterNodeModel]) ?? []  {
            
            item.dy_isUnfold = false;
        }
        self.searchCellIndexs.removeAll();
    }
    
    private func search(for title: String, result: DYTableView_Result) {
        
        if title.count == 0 {
            return;
        }
        self.clearSearchResult();
        var results: [TestCenterNodeModel] = [];

        for item in self.searchDatas {
            if  let model = self.getSearchResult(title: title, model: item) {
                model.dy_isUnfold = false;
                results.append(model)
            }
        }
        for (index,item) in results.enumerated() {
            self.searchCellIndexs[item.dy_id ?? ""] = index;
        }
                 
        result(results);
    }
    
    private func getSearchResult(title: String, model: TestCenterNodeModel) -> TestCenterNodeModel? {
        
        var children: [TestCenterNodeModel] = [];
        var newModel = model.copy() as? TestCenterNodeModel;
        for item in model.dy_children ?? [] {
            let newItem = self.getSearchResult(title: title, model: item);
            //当前的model包含 或者他的子节点包含 就证明有结果
            if item.dy_title?.contains(title) ?? false || newItem?.dy_children != nil {
                
                if let childrenNode = item.copy() as? TestCenterNodeModel {
                    children.append(childrenNode);
                }
            }
        }
        if children.count > 0 {
            newModel?.dy_children = children;
        } else {
            newModel?.dy_children = nil;
        }
        if newModel?.dy_title?.contains(title) ?? false || newModel?.dy_children != nil {
            
            if let resultNode = newModel{
                return resultNode;
            }
            return nil;
        }
        
        return nil;
    }
    
    
    
    
}
