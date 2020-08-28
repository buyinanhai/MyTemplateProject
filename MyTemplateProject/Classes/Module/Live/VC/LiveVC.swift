//
//  LiveVC.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/8/18.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit
import NCNLivingSDK


class LiveVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "自研直播测试";
        self.view.backgroundColor = .white;
        self.view.addSubview(self.enterBtn);
        self.enterBtn.mas_makeConstraints { (make) in
            make?.center.offset();
        }
        
        self.enterBtn.addTarget(self, action: #selector(enterBtnClick), for: .touchUpInside);
        self.view.addSubview(self.idField);
        self.idField.mas_makeConstraints { (make) in
            make?.centerX.offset();
            make?.top.offset()(100);
            make?.left.right();
        }
        // Do any additional setup after loading the view.
        //test 1400375080  dev 1400327132
//        NCNLivingSDK.setup(withTcentIM_AppID: "1400375080");

    }
    
    @objc
    private func enterBtnClick() {
        
        self.enterLivingRoom();
        
        
        
    }

    private func enterLivingRoom() {
        
        NCNNetwork.shared().baseURL = "http://test.sdk.live.cunwedu.com.cn";
        let model = NCNLivingRoomModel.init();
        //3051876(我的) 3051998
        model.studentId = "3051998";
        
        model.liveRoomId = "741c2080757a4ae6b59b482a1362aef3";
        if self.idField.text?.count ?? 0 > 0 {
            model.liveRoomId = self.idField.text ?? "";
        }
        
        DYNetworkHUD.startLoading();
        NCNNetwork.getLiveRoomParameters(withRoomID: model.liveRoomId, studentId: model.studentId, companyId: "138363") { (error, response) in
            DYNetworkHUD.dismiss();
            if let data = response?["data"] as? [String : Any] {
                
                if let flag = response?["flag"] as? Int, flag == 0 {
                    let jsonData = try? JSONSerialization.data(withJSONObject: response as Any, options: .prettyPrinted);
                    print("直播间参数：\(try? JSONSerialization.jsonObject(with: jsonData ?? Data.init(), options: .allowFragments) )");
                    model.studentSignIdentifier = data["token"] as? String ?? "";
                    model.liveAppid = UInt32(data["trtcAppId"] as? Int ?? 0);
                    model.liveUserSign = data["trtcSig"] as? String ?? "";
                    model.im_appId = "\(data["imAppId"] as? Int ?? -1)";
                    if let cml = data["cml"] as? [String : Any] {
                        
                        model.teacherName = "\(cml["teachersName"] as? String ?? "")";
                        model.courseDesc = cml["lessonName"] as? String ?? "";
                        model.groupChatId = "\(cml["id"] as? Int ?? -1)";
                        model.groupCodeId = model.groupChatId;
                        model.teacherId = cml["teachers"] as? String ?? "";
                        model.tc_liveRoomid = UInt32(model.groupChatId) ?? 0;
                    }
                    let vc = NCNLivingMainVC.init(roomModel: model);
                    
                    self.present(vc, animated: true, completion: nil);
                } else {
                    
                    DYNetworkHUD.showInfo(message: response?["msg"] as? String ?? "进入失败", inView: self.view);
                }
                
            } else {
                
                DYNetworkHUD.showInfo(message: "加载失败", inView: self.view)
            }
            
        }
        
      
    }
    
    private lazy var enterBtn: UIButton = {
        
        let view = UIButton.init(type: .system);
        view.setTitle("进入直播间", for: .normal);
        
        return view;
    }()
    private lazy var idField: UITextField = {
        
        let view = UITextField.init();
        view.placeholder = "可输入直播间id";
        
        return view;
    }()
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.idField.endEditing(true);
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
