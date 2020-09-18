//
//  YZDTestAnswerVC.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/7/14.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit

import DYTemplate
/**
 答题
 */
class YZDTestAnswerVC: UIViewController {

    
    
    public var afterWorkId: Int?
    
    private var afterWorkFinishId:Int?
    /**
     是否可以点击下一题 在没选择答案的情况下
     */
    internal var isEnableClickNoAnswer: Bool {
        
        get {
            return true;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "答题";
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "提交", style: .plain, target: self, action: #selector(rightBatButtonClick));
        self.setupSubview();
        self.loadData();
        // Do any additional setup after loading the view.
    }
    
    private func setupSubview() {
        
        self.view.backgroundColor = .init(hexString: "#F7F7F7");
        self.edgesForExtendedLayout = UIRectEdge.init() ;
        headerView.backgroundColor = .white;
        self.view.addSubview(headerView);
        headerView.mas_makeConstraints { (make) in
            make?.top.offset()(20);
            make?.left.offset()(15)
            make?.right.offset()(-15);
            make?.height.offset()(44);
        }
        self.headerView.collectBtn.addTarget(self, action: #selector(collectBtnClick(_ :)), for: .touchUpInside);
            
        
        self.view.addSubview(self.webView);
        self.webView.mas_makeConstraints { (make) in
            make?.left.offset()(15);
            make?.right.offset()(-15);
            make?.top.equalTo()(headerView.mas_bottom);
            make?.bottom.offset()(-62);
        }

        
        self.view.addSubview(bottomView);
        bottomView.nextBtn.addTarget(self, action: #selector(nextBtnClick), for: .touchUpInside);
        bottomView.beforeBtn.addTarget(self, action: #selector(beforeBtnClick), for: .touchUpInside);
        bottomView.mas_makeConstraints { (make) in
            make?.left.right()?.bottom()?.offset();
            make?.height.offset()(62);
        }
        bottomView.addShadow(2, round: 2);
        bottomView.beforeBtn.isEnabled = false;
        bottomView.nextBtn.isEnabled = false;
        
    }
    
    //MARK: 更新右上角的按钮状态  提交 成功后 变成查看结果
    internal func
        updateRightBarButton(_ isSubmit: Bool) {
        
        self.isSubmitAnswer = isSubmit;
        self.navigationItem.rightBarButtonItem?.title = isSubmit ? "查看结果" : "提交";
        
    }
    
    private func updateCurrentState() {
        
        //如果这道题没有作答并且 不允许在没提交答案的情况下到下一题
        if (self.answersCache[self.currentIndex]?.count ?? 0) == 0 && !self.isEnableClickNoAnswer {
            self.bottomView.nextBtn.isEnabled = false;
        } else if (self.answersCache[self.currentIndex]?.count ?? 0 > 0 && !self.isEnableClickNoAnswer) {
            self.bottomView.nextBtn.isEnabled = true;
        }
        if self.currentIndex == self.allTests.count - 1 {
            self.bottomView.nextBtn.isEnabled = false;
        }
        
        self.headerView.previewLabel.text = "\(self.currentIndex + 1)/\(self.allTests.count)";
        
        let typeName = self.getCurrentQuestionValue(for: "questionTypeName") as? String;
        self.headerView.typeLabel.text = typeName;
        self.headerView.collectBtn.isSelected = self.collectionCache[self.currentIndex] ?? false;
        self.reloadWebViewContent();

    }
    
    private func getCurrentQuestionValue(for key:String) -> Any? {
       
        var value: Any?
        
        if let question = self.allTests[self.currentIndex]["questionVo"] as? [String : Any] {
            
            value = question[key];
        }
        
        
        return value;
       
        
    }
    
   
    
    //MARK: 重新加载webview
    internal func reloadWebViewContent() {
        if self.allTests.count == 0 {
            return;
        }
        
        guard let question = self.allTests[self.currentIndex]["questionVo"] as? [String : Any] else {
            return;
        }
        
        if let jsonStr = try? String.init(data: JSONSerialization.data(withJSONObject: question, options: .fragmentsAllowed), encoding: .utf8) {
            
            self.webView.evaluateJavaScript("onload(\(jsonStr))") {[weak self] (result, error) in
                
                print("题目加载  error == \(error)");
                if error != nil {
                    self?.isSuccessLoad = false;
                }
            }
        }
    }

    
    
    private lazy var webView: WKWebView = {
           
           let config = WKWebViewConfiguration.init();
           let userCtrol = WKUserContentController.init();
           config.userContentController = userCtrol;
           let view = WKWebView.init(frame: .zero, configuration: config);
            //如果不是当前控制器就加载 练习中心html
           let html = self.isEnableClickNoAnswer ? "test-html/taskQue.html" : "test-html/testCenterQue.html"
           let path = Bundle.main.path(forResource: html, ofType: nil)
           let request = URLRequest.init(url: URL.init(fileURLWithPath: path ?? ""))
           view.load(request);
           view.navigationDelegate = self;
           view.uiDelegate = self;
            view.dy_addScriptMessageHandler(self, name: "selectAnswer");
        
           return view;
       }()

    //第一次加载 有可能会失败
    private var isSuccessLoad:Bool = true;
    internal var allTests: [[String : Any]] = [];

    private var isSubmitAnswer: Bool = false;
    /**
     当前的题目的index
     */
    private var currentIndex: Int = 0;
    
    /**
        选择的答案
     */
    private var answersCache: [Int : String] = [:];
    
    /**
     收藏的标记
     */
    private var collectionCache:[Int : Bool] = [:];
    internal var headerView: YZDTestAnswerHeaderView = {
        
        let view = YZDTestAnswerHeaderView.init(frame: .zero);
        
        return view;
    }()
    internal var bottomView: YZDTestAnswerBottomView = {
        
        let view = YZDTestAnswerBottomView.init(frame: .zero);
        
        return view;
    }()
    
    deinit {
        print("YZDTestAnswerVC 8888")
        self.webView.configuration.userContentController.removeScriptMessageHandler(forName: "selectAnswer");
    }
}

//MARK: actions
extension YZDTestAnswerVC {
    
    
    @objc private func collectBtnClick(_ sender: UIButton) {
        
        if self.allTests.count == 0 {
            return;
        }
        
        sender.isSelected = !sender.isSelected;
        
        self.collectionCache[self.currentIndex] = sender.isSelected;
        
        if let questionId = self.getCurrentQuestionValue(for: "questionId") as? Int {
            DYNetworkHUD.startLoading();
            YZDHomeworkNetwork.collectQuestion(afterWorkId: self.afterWorkId, questionId: questionId, likeOrUnlike: sender.isSelected ? 1 : 0).dy_startRequest { (response, error) in
                
                DYNetworkHUD.dismiss();
                if error != nil {
                    DYNetworkHUD.showInfo(message: error?.errorMessage ?? "操作失败", inView: nil);
                    sender.isSelected = false;
                }
            }
        }
    }
    
    @objc
    private func nextBtnClick() {
        
        self.currentIndex += 1;
        
        
        self.bottomView.beforeBtn.isEnabled = true;
        
        if self.currentIndex == self.allTests.count - 1 {
            self.bottomView.nextBtn.isEnabled = false;
        }
        
       
        self.updateCurrentState()

        
    }
    
    @objc
    private func beforeBtnClick() {
        
        self.currentIndex -= 1;

        
        if self.currentIndex == 0 {
            self.bottomView.beforeBtn.isEnabled = false;
        } else if self.currentIndex > 1 && self.currentIndex < self.allTests.count {
            self.bottomView.nextBtn.isEnabled = true;
        }
        self.updateCurrentState()
        
    }
    
    @objc
    private func rightBatButtonClick() {
        
        if self.allTests.count == 0 {
            return;
        }
        if self.answersCache.keys.count == 0 {
            
            DYNetworkHUD.showInfo(message: "请至少完成一题！", inView: nil);
            return;
            
        } else if self.isSubmitAnswer {
            
            self.commitAnswers();
            
        } else if self.answersCache.keys.count < self.allTests.count {
                        
            let alertVC = UIAlertController.showCustomAlert(withTitle: "确定提交", messgae: "您的作业未做完，确定提交吗？", confirmTitle: "提交", cancleTitle: "取消") {
                [weak self] in
                self?.commitAnswers();
                
            };
            
            self.present(alertVC, animated: true, completion: nil);
            
        } else {
            self.commitAnswers();
        }
        
        
        
    }
    
    private var hasNext: Bool {
        
        get {
            
            return self.currentIndex < self.allTests.count - 1;
        }
        
    }
    
}

//MARK: 数据加载
extension YZDTestAnswerVC {
    
    
    private func commitAnswers() {
                
        if self.isSubmitAnswer {
            
            self.showResultVC();
            
        } else {
            
            let answers = self.answersCache.map { (value) -> [String : String] in
                var questionid: Int?
                if let question = self.allTests[value.key]["questionVo"] as? [String : Any] {
                    questionid = question["questionId"] as? Int;
                }
                return  ["questionId": String(questionid ?? 0),"answer" : value.value];
            }
            self.headerView.stopReckonBytime();
            self.commitAnswer(answers: answers)
        }
        
        
        
    }
    
    @objc
    internal func commitAnswer(answers: [[String:String]]) {
            
        DYNetworkHUD.startLoading()
        YZDHomeworkNetwork.commitAnswers(afterWorkId: self.afterWorkId ?? 0, usedTime: self.headerView.getUsedTime(), answers: answers).dy_startRequest { (response, error) in
            
            if error != nil {
                DYNetworkHUD.showInfo(message: error?.errorMessage ?? "提交失败!", inView: nil);
            } else {
                self.updateRightBarButton(true);
                if let _response = response as? [String :Any] {
                    
                    self.afterWorkFinishId = _response["afterWorkFinishId"] as? Int;
                }
                DYNetworkHUD.showInfo(message: "提交成功!", inView: nil);
                
            }
        }
        
        
    }
    @objc
    internal func showResultVC() {
        
        let model = YZDTestRecordCellModel.init(JSON: [:]);
        model?.dy_afterWorkId = self.afterWorkId;
        model?.dy_afterWorkFinishId = self.afterWorkFinishId;
        let vc = YZDTestResultVC.init();
        vc.recordModel = model;
        
        self.navigationController?.pushViewController(vc, animated: true);
        
    }
    
    
    @objc
    internal func loadData() {
        
        DYNetworkHUD.startLoading()
        YZDHomeworkNetwork.getHomeworkQuestions(afterWorkId: self.afterWorkId ?? 0).dy_startRequest { (response, error) in
         
            DYNetworkHUD.dismiss();
            if let _response = response as? [String : Any] {
                
                if let items = _response["questions"] as? [[String : Any]] {
                    
                    self.show(questions: items);
                }
                
            } else {
                
                DYNetworkHUD.showInfo(message: error?.errorMessage ?? "没有相关试题", inView: nil);
            }
            
        }
        
    }
    
    @objc
    internal func show(questions: [[String : Any]]) {
        
        self.allTests = questions;
        
        if self.allTests.count == 0 {
            DYNetworkHUD.showInfo(message: "没有试题", inView: nil);
        } else {
            self.reloadWebViewContent();
            if questions.count > 1  && self.isEnableClickNoAnswer {
                //默认下一题可以点击
               
                self.bottomView.nextBtn.isEnabled = true;
            }
            self.headerView.startReckonByTime();
            self.headerView.previewLabel.text = "\(self.currentIndex + 1)/\(questions.count)";
        }
        
    }
    
}

//MARK: 代理相关
extension YZDTestAnswerVC: WKScriptMessageHandler,WKNavigationDelegate, WKUIDelegate {
       
        
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if message.name == "selectAnswer" {
            
            if let answer = message.body as? String {
                
                if answer.count > 0 {
                    
                    self.answersCache[self.currentIndex] = answer;
                    
                    if !self.isEnableClickNoAnswer && self.hasNext {
                        self.bottomView.nextBtn.isEnabled = true;
                    }
                   
                } else {
                    self.answersCache.removeValue(forKey: self.currentIndex);
                }
                if var question = self.allTests[self.currentIndex]["questionVo"] as? [String : Any] {
                    question["myAnswer"] = answer;
                    var test = self.allTests[self.currentIndex] ;
                    test["questionVo"] = question;
                    self.allTests[self.currentIndex] = test;
                }
            }
            print("当前第\(self.currentIndex + 1)题， 选择的答案为\(message.body)");
        }
        
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        if isSuccessLoad == false {
            self.reloadWebViewContent();
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



internal class YZDTestAnswerHeaderView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.setuSubview();
        
    }
    
    public func hideTimeView() {
        
        self.timeBtn.isHidden = true;
        
    }
    
    public func getUsedTime() -> Int {
        
        return self.time;
    }
    
    public func startReckonByTime() {
        
        if self.timer == nil {
            self.timer = Timer.dy_scheduledWeakTimer(withTimeInterval: 1.0, target: self, selector: #selector(self.timerFire), userInfo: [:], repeats: true);
        }
        
    }
    
    public func stopReckonBytime() {
        
        self.timer?.invalidate();
        self.timer = nil;
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func timerFire() {
        
        self.time += 1;
        let content = String.init(format: "%02d:%02d:%02d", self.time / 3600, self.time / 60, self.time % 60);
        
        self.timeBtn.setTitle(content, for: .normal);
        
    }
    
    private func setuSubview() {
        
        self.addSubview(self.typeLabel);
        self.addSubview(self.timeBtn);
        self.addSubview(collectBtn);
        self.addSubview(previewLabel);
        
        self.typeLabel.mas_makeConstraints { (make) in
            make?.left.offset()(15);
            make?.top.offset()(8);
            make?.width.offset()(60);
            make?.height.offset()(26);
            
        }
        
        self.timeBtn.mas_makeConstraints { (make) in
            make?.centerX.offset();
            make?.width.offset()(140);
            make?.height.offset()(40);
            make?.top.offset()(-4.5);
        }
    
        self.previewLabel.mas_makeConstraints { (make) in
            make?.right.offset()(-15);
            make?.bottom.equalTo()(self.timeBtn);
        }
        
        self.collectBtn.mas_makeConstraints { (make) in
            make?.bottom.equalTo()(self.previewLabel);
            make?.size.offset()(20);
            make?.right.equalTo()(self.previewLabel.mas_left)?.offset()(-10);
        }
        
        
    }
    
    
    lazy var typeLabel: UILabel = {
        
        let view = UILabel.init();
        view.backgroundColor = .init(hexString: "#FFEEEE");
        view.textColor = .init(hexString: "#E37171");
        view.font = .systemFont(ofSize: 14);
        view.addRound(5.5)
        view.text = "单选题";
        view.textAlignment = .center;
        
        return view;
    }()

    private lazy var timeBtn: DYButton = {
        
        let view = DYButton.init();
        
        view.setBackgroundImage(UIImage.init(named: "yzd-homework-time-background"), for: .normal);
        view.setImage(UIImage.init(named: "yzd-homework-timelimit"), for: .normal);
        view.textColor = .white;
        view.margin = 15;
        view.titleLabel?.font = .systemFont(ofSize: 17);
        view.text = "00:00:00";
        
        return view;
    }()
    
    lazy var collectBtn: UIButton = {
        
        let view = UIButton.init();
        view.setImage(UIImage.init(named: "yzd-homework-uncollect"), for: .normal);
        view.setImage(UIImage.init(named: "yzd-homework-collect"), for: .selected);
        return view;
    }()
    
    var previewLabel: UILabel = {
        
        let view = UILabel.init();
        view.font = .systemFont(ofSize: 14)
        view.textColor = .init(hexString: "#555555");
        view.text = "0/0";
        return view;
    }()
    
    private weak var timer: Timer?
    
    private var time: Int = 0;
    
    
    deinit {
        
        print("YZDTestAnswerHeaderView 8888");
    }
}


internal class YZDTestAnswerBottomView: UIView {
    
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame);
        
        self.backgroundColor = .white;
        self.addSubview(self.beforeBtn);
        self.addSubview(self.nextBtn);
        
        self.nextBtn.mas_makeConstraints { (make) in
            make?.left.equalTo()(self.mas_centerX)?.offset()(25);
            make?.centerY.offset();
            make?.width.offset()(88);
            make?.height.offset()(32);
        }
        
        self.beforeBtn.mas_makeConstraints { (make) in
            make?.right.equalTo()(self.mas_centerX)?.offset()(-25);
            make?.centerY.offset();
            make?.width.offset()(88);
            make?.height.offset()(32);
        }
        

        
    }
  
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    
    
    public lazy var nextBtn: UIButton = {
        
        let view = UIButton.init();
        view.setTitleColor(.init(hexString: "#F0792D"), for: .normal);
        view.setTitleColor(.init(hexString: "#B2B2B2"), for: .disabled);
        view.setTitle("下一题", for: .normal);
        view.titleLabel?.font = .systemFont(ofSize: 13)
        view.backgroundColor = .init(hexString: "#fedac8");
        view.addRound(16);
        return view;
    }()
    public lazy var beforeBtn: UIButton = {
        
        let view = UIButton.init();
        view.setTitleColor(.init(hexString: "#2B44AD"), for: .normal);
        view.setTitleColor(.init(hexString: "#B2B2B2"), for: .disabled);
        view.setTitle("上一题", for: .normal);
        view.titleLabel?.font = .systemFont(ofSize: 13)
        view.backgroundColor = .init(hexString: "#dbdbf3");
        view.addRound(16);
        
        return view;
    }()
    
}
