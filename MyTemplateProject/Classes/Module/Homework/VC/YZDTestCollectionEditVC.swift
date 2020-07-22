//
//  YZDTestCollectionEditVC.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/7/14.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit


/**
 错题集编辑
 */
class YZDTestCollectionEditVC: UIViewController {

    public var allTests:[[String : Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.addSubview(self.webView)
        self.webView.mas_makeConstraints { (make) in
            make?.edges.offset();
        }
        self.navigationItem.title = "编辑错题集";

        // Do any additional setup after loading the view.
    }
    
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
            self.webView.evaluateJavaScript("onload(\(jsonStr))") { (result, error) in
                
                print("题目加载  error == \(error)");
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

}


extension YZDTestCollectionEditVC: WKScriptMessageHandler,WKNavigationDelegate {
    
    
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
        
           
        self.reloadWebViewContent();
        
    }
    
}
