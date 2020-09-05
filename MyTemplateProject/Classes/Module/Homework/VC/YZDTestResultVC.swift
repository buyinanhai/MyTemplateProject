//
//  YZDTestResultVC.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/7/14.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit
import WebKit
import DYTemplate
/**
 作业中心答题结果
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
                
        
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData))
        
        self.tableView.mj_header?.beginRefreshing()
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.tableView.tableHeaderView == nil {
            let header = YZDTestResultHeader.initHeaderView();
            header.delegate = self;
            self.tableView.tableHeaderView = header;
            self.tableView.tableHeaderView?.frame = CGRect.init(x: 0, y: 0, width: self.view.width, height: 180);
            
            header.didSelectedCell = {
                [weak self] (index) in
                if index < self?.allTests.count ?? 0 {
                   
                    self?.webView?.evaluateJavaScript("doScroll('\(index)')", completionHandler: nil);
                }
            }
        }
    }
    
    internal func updateHeaderView(_ model: YZDTestResultDetailInfo, results:[Int : String]) {
    
        (self.tableView.tableHeaderView as? YZDTestResultHeader)?.update(model, results: results);
    
    }
    
    //MARK: 重新加载webview
    internal func reloadWebViewContent() {
        if self.allTests.count == 0 {
            return;
        }
        
        if let jsonStr = try? String.init(data: JSONSerialization.data(withJSONObject: self.allTests, options: .fragmentsAllowed), encoding: .utf8) {
            self.webView?.evaluateJavaScript("onload(\(jsonStr))") { (result, error) in
                
                print("题目加载  error == \(error)");
                if error != nil {
                    self.isSuccessLoad = false;
                }
            }
        }
    }
    
    
    @objc
    internal func loadData() {
        
        
        if let _model = self.recordModel {
            YZDHomeworkNetwork.getMyHomeworkResult(afterWorkId: _model.dy_afterWorkId ?? 0, afterWorkFinishId: _model.dy_afterWorkFinishId ?? 0).dy_startRequest { (response, error) in
                
                self.tableView.mj_header?.endRefreshing();
                if let _response = response as? [String : Any] {
                    
                    var results:[Int: String] = [:];
                    
                    if let items = _response["questions"] as? [[String : Any]] {
                        
                        self.allTests = items;
                        
                        for (index,item) in items.enumerated() {
                            if let rightFlag = item["rightFlag"] as? Int {
                                
                                results[index] = "\(rightFlag)";
                                
                            } else {
                                results[index] = "-1";
                            }
                        }
                        self.reloadWebViewContent();
                    }
                    if let info = _response["AfterWork"] as? [String : Any], let model = YZDTestResultDetailInfo.init(JSON: info) {
                        
                        self.updateHeaderView(model, results: results);
                    }
                    
                } else {
                                        
                    DYNetworkHUD.showInfo(message: error?.errorMessage ?? "获取失败", inView: nil);
                    
                }
                
            }
        }
        
    }
    
    
    
    internal lazy var tableView: UITableView = {
        
        let view = UITableView.init(frame: .zero);
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell");
        view.separatorStyle = .none;
        view.allowsSelection = false;
        view.dataSource = self;
        view.delegate = self;
        
        
        return view;
        
    }()
    
    private weak var webView:WKWebView?
    
    private var isSuccessLoad:Bool = true;
    internal var allTests: [[String : Any]] = [];


}

extension YZDTestResultVC : YZDTestResultHeaderDelegate {
    
    func headerView(_ view: YZDTestResultHeader, onClickFolder isUnfold: Bool) {
        
        if self.allTests.count == 0 { return}
        
//        let height = (self.tableView.tableHeaderView as? YZDTestResultHeader)?.getHeight(for: isUnfold);
//        var frame = self.tableView.tableHeaderView?.frame;
//        frame?.size.height = height ?? view.height;
//        self.tableView.tableHeaderView?.frame = frame;
        self.tableView.reloadData();
    
    }

    func headerView(_ view: YZDTestResultHeader, didSelected indexPath: IndexPath) {
        
        
    }
}

extension YZDTestResultVC: UITableViewDataSource,UITableViewDelegate,WKNavigationDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        
        var webView = cell.contentView.subviews.first as? WKWebView ;
        if webView == nil {
            let config = WKWebViewConfiguration.init();
            webView = WKWebView.init(frame: .zero, configuration: config);
            let path = Bundle.main.path(forResource: "test-html/taskResultList.html", ofType: nil)
            let request = URLRequest.init(url: URL.init(fileURLWithPath: path ?? ""))
            webView!.load(request);
            webView!.navigationDelegate = self;
            webView?.scrollView.delegate = self;
            cell.contentView.addSubview(webView!);
            webView?.mas_makeConstraints({ (make) in
                make?.edges.offset();
            })
            self.webView = webView;
        }
    
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height = self.tableView.height - (self.tableView.tableHeaderView?.height ?? 0);
        if height < 0 {
            height = self.tableView.height;
        }
        
        return height;
    }
    

    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        if isSuccessLoad == false {
            self.reloadWebViewContent();
        }
    }
    
    
    
}
