//
//  TestWebViewVC.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/7/21.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit

class TestWebViewVC: UIViewController {

    public var productId: Int?
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        self.view.addSubview(self.webView);
               self.webView.mas_makeConstraints { (make) in
                   make?.edges.offset();
               }
      
//        self.webView.scrollView.mj_header?.beginRefreshing {
//
//        }
        self.webView.load(URLRequest.init(url: URL.init(string: "https://test.uaregood.net/mobile#/home?token=eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJqd3QiLCJpYXQiOjE2MDQzNzIzNzAsInN1YiI6IntcImlkXCI6XCI2OTc4NTQ4NzI2OTkxNDYyNDBcIixcImFjY291bnRcIjpcIjEwMDU0QzAwMDNcIixcImFwcENvZGVcIjpcIkEwN1wiLFwidXNlckZsYWdcIjowfSIsImlzcyI6ImN1bnciLCJleHAiOjE2MDQzODY3NzB9.Q6BOQ9tcJsppoF-g1bpBN1PY2n2EsHUKUVro_sBiNkY&platform=app&t=1604372370661.02")!));
        // Do any additional setup after loading the view.
    }
    

    @objc
    private func loadData() {
//        let pageSize = 4;
//        YZDHomeworkNetwork.getMyErrorCollections(classTypeId: self.productId ?? 0, subjectId: nil, gradeId: nil, page: self.currentPage, pageSize: pageSize).dy_startRequest { (response, error) in
//            self.webView.scrollView.mj_header?.endRefreshing();
//            self.webView.scrollView.mj_footer?.endRefreshing();
//            if let _response = response as? [String : Any], let items = _response["list"] as? [[String : Any]] {
//
//                if self.currentPage == 0 {
//                    self.allTests.removeAll();
//                    self.allTests.append(contentsOf: items);
//
//                    if self.webView.scrollView.mj_footer == nil && items.count == pageSize {
//                        self.webView.scrollView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.loadMoreData));
//                    }
//                } else {
//                    self.allTests.append(contentsOf: items);
//                    if items.count < pageSize {
//                        self.webView.scrollView.mj_footer?.endRefreshingWithNoMoreData();
//                    }
//                }
//                self.reloadWebViewContent();
//
//
//            } else {
//                DYNetworkHUD.showInfo(message: error?.errorMessage ?? "没有错题数据", inView: nil)
//            }
//
//        }
    }
    @objc
    private func loadMoreData() {
        self.currentPage += 1;
        self.loadData();
    }

    //MARK: 从webview中删除某一道题
    private func removeQuestionFromCollections(_ index: Int) {
        
        if index < self.allTests.count {
            let dict = self.allTests[index];
            guard let questionId = dict["questionId"] as? Int else {
                return;
            }
            DYNetworkHUD.startLoading();
            YZDHomeworkNetwork.removeQuestionsFromCollections(questionIds: [questionId]).dy_startRequest { (response, error) in
                
                if let _  = response as? [String : Any] {
                    DYNetworkHUD.showInfo(message: "操作成功！", inView: nil);
                    self.allTests.remove(at: index);
                    self.reloadWebViewContent();
                } else {
                    
                    DYNetworkHUD.showInfo(message: error?.errorMessage ?? "操作失败", inView: nil);
                    
                }
                
            }
        }
        
        
    }
    //MARK: 重新加载webview
    private func reloadWebViewContent() {
        if let jsonStr = try? String.init(data: JSONSerialization.data(withJSONObject: self.allTests, options: .fragmentsAllowed), encoding: .utf8) {
            self.webView.evaluateJavaScript("onload(\(jsonStr ?? ""))") { (result, error) in
                
                print("题目加载  error == \(error)");
                if error != nil {
                    self.isSuccessLoad = false;
                }
            }
        }
    }
    
    
    private lazy var webView: WKWebView = {
        
        let config = WKWebViewConfiguration.init();
        let userCtrol = WKUserContentController.init();
        userCtrol.add(self, name: "removeThisQuestion");
        config.userContentController = userCtrol;
        let view = WKWebView.init(frame: .zero, configuration: config);
        let path = Bundle.main.path(forResource: "test-html/wrongQueList.html", ofType: nil)
        let request = URLRequest.init(url: URL.init(fileURLWithPath: path ?? ""))
        view.load(request);
        view.navigationDelegate = self;
        view.uiDelegate = self;
        view.scrollView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData));
      

        
        return view;
    }()
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    private var allTests: [[String : Any]] = [];
    
    private var currentPage: Int = 0;

    //第一次加载 有可能会失败
    private var isSuccessLoad:Bool = true;
    
    
    
    deinit {
        self.webView.configuration.userContentController.removeScriptMessageHandler(forName: "removeThisQuestion");
    }
    
}
extension TestWebViewVC: WKScriptMessageHandler,WKNavigationDelegate, WKUIDelegate {
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if message.name == "removeThisQuestion" {
            
           let alertVC =  UIAlertController.showCustomAlert(withTitle: "温馨提示", messgae: "确定将此题移出错题集吗？", confirmTitle: "确认", cancleTitle: "取消") {
                if let index = message.body as? Int {
                    self.removeQuestionFromCollections(index);
                }
            }
            self.present(alertVC, animated: true, completion: nil);
        }
        
        
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        if isSuccessLoad == false {
            if let jsonStr = try? String.init(data: JSONSerialization.data(withJSONObject: self.allTests, options: .fragmentsAllowed), encoding: .utf8) {
                self.webView.evaluateJavaScript("onload(\(jsonStr ?? ""))") { (result, error) in
                    
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
 

//拦截类
class CustomURLSchemeHandler: NSObject {
    
}

@available(iOS 11.0, *)
extension CustomURLSchemeHandler:WKURLSchemeHandler{
    
    @available(iOS 11.0, *)
    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        
        //文件名
        let fileName = urlSchemeTask.request.url?.lastPathComponent
        //文件扩展名（文件类型）
        let pathExtension = urlSchemeTask.request.url?.pathExtension
        
        //获取本地资源
        let fileURL = Bundle.main.url(forResource: fileName?.components(separatedBy: ".").first, withExtension: pathExtension)
        
        //本地存在文件
        if fileURL != nil{
            //获取本地资源异常
            do {
                //返回本地数据
                let data:NSData = try Data.init(contentsOf: fileURL!) as NSData
                let pathExtension = fileURL!.pathExtension
                let mime = mimeType(forPathExtension: pathExtension)
                
                let response:URLResponse = URLResponse.init(url: urlSchemeTask.request.url!, mimeType: mime, expectedContentLength: data.length, textEncodingName: nil)
                urlSchemeTask.didReceive(response)
                urlSchemeTask.didReceive(data as Data)
                urlSchemeTask.didFinish()
            }catch {
                //本地资源获取异常
                requestWebViewData(urlSchemeTask: urlSchemeTask)
            }
        }else{
            //无本地资源
            requestWebViewData(urlSchemeTask: urlSchemeTask)
        }
    }
    
    @available(iOS 11.0, *)
    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        
    }
    
    /// 代替H5发出网络请求
    ///
    /// - Parameter urlSchemeTask:
    private func requestWebViewData(urlSchemeTask: WKURLSchemeTask){
        let schemeUrl:String = urlSchemeTask.request.url?.absoluteString ?? ""  //***这个搞过来好像都是小写的
        //换成原始的请求地址
        let replacedStr = schemeUrl.replacingOccurrences(of: "yjkcustomscheme", with: "https")
        //发出请求结果返回
        let request = URLRequest.init(url: URL.init(string: replacedStr)!)
        let config = URLSessionConfiguration.default
        let session = URLSession.init(configuration: config)
        let dataTask = session.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            if error != nil{
                urlSchemeTask.didFailWithError(error!)
            }else{
                urlSchemeTask.didReceive(response!)
                urlSchemeTask.didReceive(data!)
                urlSchemeTask.didFinish()
            }
        }
        dataTask.resume()
    }
    
    /// 获取文件类型
    ///
    /// - Parameter pathExtension:
    /// - Returns:
    private func mimeType(forPathExtension pathExtension: String) -> String {
//        if
//            let id = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as CFString, nil)?.takeRetainedValue(),
//            let contentType = UTTypeCopyPreferredTagWithClass(id, kUTTagClassMIMEType)?.takeRetainedValue()
//        {
//            return contentType as String
//        }
//
        return "application/octet-stream"
    }
}
