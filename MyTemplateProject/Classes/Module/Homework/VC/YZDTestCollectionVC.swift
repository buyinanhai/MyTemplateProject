//
//  YZDTestCollectionVC.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/7/14.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit
import DYTemplate
/**
 错题集
 */
class YZDTestCollectionVC: UIViewController {

    
    public var productId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "课程错题";
        self.setupSubview();
        self.webView.scrollView.mj_header?.beginRefreshing()
        self.loadData();
        // Do any additional setup after loading the view.
    }
    
    private func setupSubview() {
        
        self.edgesForExtendedLayout = UIRectEdge.init();
        
        self.view.addSubview(self.gradeBtn);
        self.gradeBtn.mas_makeConstraints { (make) in
            make?.left.top()?.offset();
            make?.width.offset()(100);
            make?.height.offset()(self.headerHeight);
        }
        self.gradeBtn.addTarget(self, action: #selector(gradeBtnClick), for: .touchUpInside)
        
        self.view.addSubview(self.sliderView);
        self.sliderView.mas_makeConstraints { (make) in
            make?.right.top()?.offset();
            make?.height.offset()(self.headerHeight);
            make?.left.equalTo()(self.gradeBtn.mas_right);
        }
        self.sliderView.selectIndexBlock = {
            [weak self] (index) in
            self?.onSubjectBtnClick(index);
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "编辑", style: .plain, target: self, action: #selector(rightBarButtonClick));
        self.navigationItem.rightBarButtonItem?.title = "编辑";

        self.view.addSubview(self.webView);
        self.webView.mas_makeConstraints { (make) in
            make?.left.right()?.bottom().offset();
            make?.top.equalTo()(self.sliderView.mas_bottom);
        }
        self.webView.uiDelegate = self;
        self.webView.navigationDelegate = self;
        
        self.view.addSubview(self.editView);
        self.editView.mas_makeConstraints { (make) in
            make?.bottom.left()?.right()?.offset();
            make?.height.offset()(55);
        }
        self.editView.addShadow(1, round: 0);
        self.editView.isHidden = true;
        self.editView.removeBtnClickCallback = {
            [weak self] in
            
            self?.removeButtonClickFromEditView();
        }
        self.editView.allSelectBtnClickCallback = {
            [weak self] (isSelect) in
            
            self?.selectAllBtnClickFromEditView(isSelect);
        }
        
    }
  
    
    //MARK: 私有属性相关

    private var currentSubjectId: String?;
    private var currentGradeId: Int?;
    /**
     0  == name  1 == subjectId
     */
    private var allSubjects: [(String,String)] = [];
    /**
     0   == id  1 == name 2 == stageId
     */
    private var allGrades: [(Int,String,Int)] = [];
    
 
    
    private var sliderView: DYSliderHeadView = {
        
        let view = DYSliderHeadView.init(titles: []);
        view.selectColor = kDY_ThemeColor;
        view.sliderLineWidth = 12;
        view.backgroundColor = .init(hexString: "#FFF5E9");

        return view;
        
    }()
    
    private var gradeBtn: DYButton = {
        
        let view = DYButton.init(type: .custom)
        view.setTitle("选择年级", for: .normal);
        view.direction = 2;
        view.margin = 8;
        view.setImage(UIImage.init(named: "yzd-homework-grade-arrow-down"), for: .normal);
        view.titleLabel?.font = UIFont.systemFont(ofSize: 17);
        view.setTitleColor(kDY_ThemeColor, for: .normal);
        view.backgroundColor = .init(hexString: "#FFF5E9");
        return view;
    }()
           
    
    private var headerHeight: CGFloat {
        
        get {
            return 44.0;
        }
    }
    
    
    private lazy var webView: WKWebView = {
        
        let config = WKWebViewConfiguration.init();
        let userCtrol = WKUserContentController.init();
       
        config.userContentController = userCtrol;
        let view = WKWebView.init(frame: .zero, configuration: config);
        let path = Bundle.main.path(forResource: "test-html/wrongQueList.html", ofType: nil)
        let request = URLRequest.init(url: URL.init(fileURLWithPath: path ?? ""))
        view.load(request);
        view.navigationDelegate = self;
        view.uiDelegate = self;
        view.scrollView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(self.loadQuestionsData));
        view.dy_addScriptMessageHandler(self, name: "removeThisQuestion");
        view.dy_addScriptMessageHandler(self, name: "onSelectCheckBox");
        
        return view;
    }()
    
    private lazy var editView: YZDTestCollectionAllSelectView = {
        
        let view = YZDTestCollectionAllSelectView.init();
        view.backgroundColor = .white;
        
        
        return view;
    }()
    
    private var currentPage: Int = 0;
    private var pageSize: Int {
        get {
            return 4;
        }
    }
    
    /**
        是否正在编辑
     */
    private var isCanEdit:Bool {
        
        get {
            return self.navigationItem.rightBarButtonItem?.title == "编辑"
        }
        
    }
    
    /**
     判断编辑之后是否需要footer
     */
    private var hasFooter: Bool = false;
    /**
     是否加载完所有数据
     */
    private var isExhaustLoadData:Bool = false;
    
    //第一次加载 有可能会失败
    private var isSuccessLoad:Bool = true;
    private var allTests: [[String : Any]] = [];

    
    /**
     将要删除的题目  只有在编辑状态下使用
     */
    private var willRemoveTests:[Int:Int] = [:]
    
    
    deinit {
        
        self.webView.configuration.userContentController.removeScriptMessageHandler(forName: "removeThisQuestion");
        self.webView.configuration.userContentController.removeScriptMessageHandler(forName: "onSelectCheckBox");

    }
}



//MARK: 代理相关
extension YZDTestCollectionVC: WKScriptMessageHandler,WKNavigationDelegate, WKUIDelegate {
       
       
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if message.name == "removeThisQuestion" {
            
            let alertVC =  UIAlertController.showCustomAlert(withTitle: "温馨提示", messgae: "确定将此题移出错题集吗？", confirmTitle: "确认", cancleTitle: "取消") {
                if let index = message.body as? Int {
                    self.removeQuestionsFromCollections([index]);
                }
            }
            self.present(alertVC, animated: true, completion: nil);
            
        } else if message.name == "onSelectCheckBox" {
            
            print("onSelectCheckBox  ：   \(message.body)");
            if let array = message.body as? [Int] {
                let index = array[0];
                let state = array[1];
                
                if state == 1 {
                    self.willRemoveTests[index] = 1;
                }
            }
        }
        
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        if isSuccessLoad == false {
            if let jsonStr = try? String.init(data: JSONSerialization.data(withJSONObject: self.allTests, options: .fragmentsAllowed), encoding: .utf8) {
                self.webView.evaluateJavaScript("onload(\(jsonStr))") { (result, error) in
                    
                    print("第二次题目加载  error == \(error)");
                    if error != nil {
                        self.isSuccessLoad = false;
                    }
                }
            }
        }
        
        
    }
    
    //MARK:WKUIDelegate
    //此方法作为js的alert方法接口的实现，默认弹出窗口应该只有提示消息，及一个确认按钮，当然可以添加更多按钮以及其他内容，但是并不会起到什么作用
    //点击确认按钮的相应事件，需要执行completionHandler，这样js才能继续执行
    ////参数 message为  js 方法 alert(<message>) 中的<message>
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertViewController = UIAlertController(title: "提示", message:message, preferredStyle: UIAlertController.Style.alert)
        alertViewController.addAction(UIAlertAction(title: "确认", style: UIAlertAction.Style.default, handler: { (action) in
            completionHandler()
        }))
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    // confirm
    //作为js中confirm接口的实现，需要有提示信息以及两个相应事件， 确认及取消，并且在completionHandler中回传相应结果，确认返回YES， 取消返回NO
    //参数 message为  js 方法 confirm(<message>) 中的<message>
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertVicwController = UIAlertController(title: "提示", message: message, preferredStyle: UIAlertController.Style.alert)
        alertVicwController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: { (alertAction) in
            completionHandler(false)
        }))
        alertVicwController.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (alertAction) in
            completionHandler(true)
        }))
        self.present(alertVicwController, animated: true, completion: nil)
    }
    
    // prompt
    //作为js中prompt接口的实现，默认需要有一个输入框一个按钮，点击确认按钮回传输入值
    //当然可以添加多个按钮以及多个输入框，不过completionHandler只有一个参数，如果有多个输入框，需要将多个输入框中的值通过某种方式拼接成一个字符串回传，js接收到之后再做处理
    //参数 prompt 为 prompt(<message>, <defaultValue>);中的<message>
    //参数defaultText 为 prompt(<message>, <defaultValue>);中的 <defaultValue>
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alertViewController = UIAlertController(title: prompt, message: "", preferredStyle: UIAlertController.Style.alert)
        alertViewController.addTextField { (textField) in
            textField.text = defaultText
        }
        alertViewController.addAction(UIAlertAction(title: "完成", style: UIAlertAction.Style.default, handler: { (alertAction) in
            completionHandler(alertViewController.textFields![0].text)
        }))
        self.present(alertViewController, animated: true, completion: nil)
    }
    
}

//MARK: 业务逻辑相关
extension YZDTestCollectionVC {
    
    private func removeQuestionsFromCollections(_ indexes: [Int]) {
        
        var surplusTests: [[String : Any]] = self.allTests;
        var questionIds: [Int] = []
        for index in indexes {
            if index < self.allTests.count {
                let dict = self.allTests[index];
                guard let questionId = dict["questionId"] as? Int else {
                    break;
                }
                questionIds.append(questionId)
                surplusTests.remove(at: index);
                
            }
        }
        if questionIds.count == 0 {
            return;
        }
        DYNetworkHUD.startLoading();
        YZDHomeworkNetwork.removeQuestionsFromCollections(questionIds: questionIds).dy_startRequest { (response, error) in
            
            if let _  = response as? [String : Any] {
                DYNetworkHUD.showInfo(message: "操作成功！", inView: nil);
                self.allTests = surplusTests;
                self.reloadWebViewContent();
            } else {
                DYNetworkHUD.showInfo(message: error?.errorMessage ?? "操作失败", inView: nil);
            }
        }
    }
    //MARK: 重新加载webview
    private func reloadWebViewContent() {
        if let jsonStr = try? String.init(data: JSONSerialization.data(withJSONObject: self.allTests, options: .fragmentsAllowed), encoding: .utf8) {
            self.webView.evaluateJavaScript("onload(\(jsonStr))") { (result, error) in
                
                print("题目加载  error == \(error)");
                if error != nil {
                    self.isSuccessLoad = false;
                }
            }
            self.webView.evaluateJavaScript("updateEditState(\(!self.isCanEdit))", completionHandler: nil);
        }
    }
    
    
}

//MARK: 加载数据
extension YZDTestCollectionVC {
        
    private func loadData() {
        
        DYNetworkHUD.startLoading()
        YZDHomeworkNetwork.getMyGrades().dy_startRequest { (response, error) in
            
            if let items = response as? [[String : Any]] {
                DYNetworkHUD.dismiss();
                for item in items {
                    if let name = item["name"] as? String, let id = item["id"] as? Int, let stageId = item["stageId"] as? Int {
                        self.allGrades.append((id, name,stageId));
                    }
                }
                
            } else {
                
                DYNetworkHUD.showInfo(message: error?.errorMessage ?? "没有年级数据", inView: nil)
            }
        }
    }
    
    @objc
    private func loadQuestionsData() {
        if self.webView.scrollView.mj_header?.isRefreshing ?? false {
            self.currentPage = 0;
        }
        YZDHomeworkNetwork.getMyErrorCollections(classTypeId: self.productId ?? 0, subjectId: self.currentSubjectId, gradeId: self.currentGradeId, page: self.currentPage, pageSize: self.pageSize).dy_startRequest { (response, error) in
            self.webView.scrollView.mj_header?.endRefreshing();
            self.webView.scrollView.mj_footer?.endRefreshing();
            if let _response = response as? [String : Any], let items = _response["list"] as? [[String : Any]] {
                
                if self.currentPage == 0 {
                    self.allTests.removeAll();
                    self.allTests.append(contentsOf: items);
                    
                    if self.webView.scrollView.mj_footer == nil && items.count == self.pageSize {
                        self.webView.scrollView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.loadMoreData));
                        self.hasFooter = true;
                        self.isExhaustLoadData = false;
                    } else {
                        self.isExhaustLoadData = true;
                    }
                    
                } else {
                    self.allTests.append(contentsOf: items);
                    if items.count < self.pageSize && self.webView.scrollView.mj_footer != nil {
                        self.webView.scrollView.mj_footer?.endRefreshingWithNoMoreData();
                        self.isExhaustLoadData = true;
                    }
                }
                self.reloadWebViewContent();
            } else {
                self.allTests.removeAll();
                self.reloadWebViewContent();
                DYNetworkHUD.showInfo(message: error?.errorMessage ?? "没有错题数据", inView: nil)
            }
            
        }
    }
    @objc
    private func loadMoreData() {
        self.currentPage += 1;
        self.loadQuestionsData();
    }
    
    //MARK: 根据年级加载科目数据
    private func loadSubjectsData(stageId: Int) {
        
        DYNetworkHUD.startLoading();
        YZDHomeworkNetwork.getMysSubjects(stagedId: stageId).dy_startRequest { (response, error) in
            
            if let items = response as? [[String : Any]] {
                DYNetworkHUD.dismiss();
                for item in items {
                    if let name = item["subjectName"] as? String, let id = item["subjectId"] as? String {
                        self.allSubjects.append((name, id));
                    }
                }
                let titles = self.allSubjects.map { (value) -> String in
                    return value.0;
                }
                self.sliderView.currSelectIndex = 0;
                self.currentSubjectId = self.allSubjects.first?.1;
                self.sliderView.updateTitles(titles);
                self.webView.scrollView.mj_header?.beginRefreshing()
                
            } else {
                
                DYNetworkHUD.showInfo(message: error?.errorMessage ?? "没有科目数据", inView: nil)
            }
            
        }
    }

}

//MARK: 处理点击事件
extension YZDTestCollectionVC {
    
    
    private func onSubjectBtnClick(_ index:Int) {
        
        if index < self.allSubjects.count {
            
            let subjectId = self.allSubjects[index].1;
            self.currentSubjectId = subjectId;
            self.webView.scrollView.mj_header?.beginRefreshing();
        }
        
        
    }
    
    private func removeButtonClickFromEditView() {
        
        let indexes = self.willRemoveTests.map({ (value) -> Int in
            return value.key;
        });
        self.removeQuestionsFromCollections(indexes);
    }
    
    private func selectAllBtnClickFromEditView(_ isSelect: Bool) {
        
        self.webView.evaluateJavaScript("selectAll(\(isSelect))", completionHandler: nil);
        DispatchQueue.global().async {
            if isSelect {
                for (index,_) in self.allTests.enumerated()  {
                    self.willRemoveTests[index] = 1;
                }
            } else {
                self.willRemoveTests.removeAll();
            }
        }
    }
    
    @objc
      private func gradeBtnClick() {
          
        if self.allGrades.count == 0 {
            self.loadData();
            return;
        }
        
          var actions:[YCMenuAction] = []
          
          for item in self.allGrades {
              if let action = YCMenuAction.init(title: item.1, image: nil) {
                  actions.append(action);
              }
          }
          let menuView = YCMenuView.menu(with: actions, width: 120, relyonView: self.gradeBtn);
          menuView?.show();
          menuView?.didSelectedCellCallback = {
              [weak self] (view, index) in
              if let tuple = self?.allGrades[index?.row ?? 0] {
                  
                  self?.currentGradeId = tuple.0;
                  self?.gradeBtn.setTitle(tuple.1, for: .normal);
                  self?.loadSubjectsData(stageId: tuple.2);
              }
          }
          
      }
      
      @objc
      private func rightBarButtonClick() {
          
          let isEdit = self.isCanEdit;
          self.webView.evaluateJavaScript("updateEditState(\(isEdit))", completionHandler: nil);
          self.navigationItem.rightBarButtonItem?.title = isEdit ? "取消": "编辑";
          self.editView.isHidden = !isEdit;
          if isEdit {
              self.webView.mas_updateConstraints { (make) in
                  make?.top.equalTo()(self.sliderView.mas_bottom)?.offset()(-self.sliderView.height);
              }
              self.webView.scrollView.mj_header = nil;
              self.webView.scrollView.mj_footer = nil;
          } else {
              self.webView.mas_updateConstraints { (make) in
                  make?.top.equalTo()(self.sliderView.mas_bottom)?.offset();
              }
              self.webView.scrollView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(self.loadQuestionsData));
              if hasFooter {
                  self.webView.scrollView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.loadMoreData));
                  if self.isExhaustLoadData {
                      self.webView.scrollView.mj_footer?.endRefreshingWithNoMoreData();
                  }
              }
              self.willRemoveTests.removeAll();
          }
        
      }
      
}

//MARK: 底部的编辑view
class YZDTestCollectionAllSelectView: UIView {
    
    
    public var removeBtnClickCallback:(() -> Void)?
    
    public var allSelectBtnClickCallback: ((Bool) -> Void)?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.addSubview(self.selectBtn);
        self.addSubview(self.removeBtn);
        
        self.selectBtn.mas_makeConstraints { (make) in
            make?.left.offset()(30);
            make?.centerY.offset();
            make?.size.offset()(20);
        }
        self.removeBtn.addRound(15);
        self.removeBtn.mas_makeConstraints { (make) in
            make?.right.offset()(-15);
            make?.centerY.offset();
            make?.width.offset()(88);
            make?.height.offset()(30);
        }
        
        
        self.selectBtn.addTarget(self, action: #selector(selectBtnClick), for: .touchUpInside);
        self.removeBtn.addTarget(self, action: #selector(removeBtnClick), for: .touchUpInside);

    }
    
    @objc
    private func removeBtnClick() {
        
        self.removeBtnClickCallback?();
    }
    
    @objc
    private func selectBtnClick() {
        
        self.selectBtn.isSelected = !self.selectBtn.isSelected;
        self.allSelectBtnClickCallback?(self.selectBtn.isSelected);
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var selectBtn: UIButton = {
        
        let view = UIButton.init();
        
        view.setImage(UIImage.init(named: "yzd-img-checkbox-normal"), for: .normal);
        view.setImage(UIImage.init(named: "yzd-img-checkbox-select"), for: .selected);
        
        return view;
    }()
    
    private lazy var removeBtn: UIButton = {
        
        let view = UIButton.init();
        
        view.setTitle("移除", for: .normal);
        view.backgroundColor = .init(hexString: "#feD6bd");
        view.setTitleColor(.init(hexString: "#F0792D"), for: .normal);
        view.titleLabel?.font = UIFont.systemFont(ofSize: 13);
        
        return view;
    }()
    
}
