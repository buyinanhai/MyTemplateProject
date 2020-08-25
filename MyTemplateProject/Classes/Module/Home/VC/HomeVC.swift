//
//  HomeVC.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/7/10.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit
import NCNLivingSDK
/**
 首页控制器
 */
class HomeVC: UIViewController {
    
     override func viewDidLoad() {
        
         super.viewDidLoad()
        self.title = "首页";
        
        self.view.addSubview(self.tableView);
        self.tableView.mas_makeConstraints { (make) in
            make?.edges.offset()
        }
         self.tableView.delegate  = self;
         self.tableView.dataSource = self;
         self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
         // Do any additional setup after loading the view.
     }
     
     private var datas: [String] = [
     
         "优智多课堂作业中心",
         "测试wkwebview",
         "练习中心",
         "手机投屏",
         "自研直播间",
         "错题集",
         
         
     ];
    
    
    private lazy var tableView: UITableView = {
        
        let view = UITableView.init()
        return view;
    }()

}


extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        cell.textLabel?.text = self.datas[indexPath.row];
        cell.accessoryType = .disclosureIndicator;
        return cell;
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var vc: UIViewController?;
        
        switch indexPath.row {
        case 0:
            vc = YZDHomeworkVC.init();
            break
        case 1:
            vc = TestWebViewVC.init();
            break;
        case 2:
            vc = TestCenterChooseVC.init();
            break;
        case 3:
            vc = APHomeVC.init();
            break;
            
        case 4:

            self.enterLivingRoom();
            
            return
            
        case 5:
            vc = YZDTestCollectionVC.init();
            break;
        default:
            break
        }

        if  let _vc = vc  {
            vc?.hidesBottomBarWhenPushed = true;
            self.navigationController?.pushViewController(_vc, animated: true);
        }
        
    }
    
    
    private func enterLivingRoom() {
        NCNNetwork.shared().baseURL = "http://test.sdk.live.cunwedu.com.cn";
        let model = NCNLivingRoomModel.init();
        model.studentId = "3051998";
        model.liveRoomId = "1b04d5ccf28649ad94f23a2446bf9ccc";
        
        DYNetworkHUD.startLoading();
        NCNNetwork.getLiveRoomParameters(withRoomID: model.liveRoomId, studentId: model.studentId, companyId: "138363") { (error, response) in
            DYNetworkHUD.dismiss();
            if let data = response?["data"] as? [String : Any] {
                
                let jsonData = try? JSONSerialization.data(withJSONObject: response as Any, options: .prettyPrinted);
                print("直播间参数：\(try? JSONSerialization.jsonObject(with: jsonData ?? Data.init(), options: .allowFragments) )");
                model.studentSignIdentifier = data["token"] as? String ?? "";
                model.liveAppid = UInt32(data["trtcAppId"] as? Int ?? 0);
                model.liveUserSign = data["trtcSig"] as? String ?? "";
                if let cml = data["cml"] as? [String : Any] {
                    
                    model.teacherName = cml["teachers"] as? String ?? "";
                    model.courseDesc = cml["lessonName"] as? String ?? "";
                    model.groupChatId = cml["id"] as? String ?? "";
                    model.groupCodeId = model.groupChatId;
                }
                let vc = NCNLivingMainVC.init(roomModel: model);
                      
                self.present(vc, animated: true, completion: nil);
            } else {
                
                DYNetworkHUD.showInfo(message: "加载失败", inView: self.view)
            }
            
        }
        
      
    }
    
}
