//
//  APHomeVC.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/8/15.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit
import DYTemplate.DYButton
import MediaPlayer
import AVKit
import MediaPlayer

class APHomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white;
        
        self.navigationItem.title = "手机投屏";
        self.view.addSubview(self.startBtn);
        self.startBtn.mas_makeConstraints { (make) in
            make?.center.offset();
            make?.width.offset()(100);
            make?.height.offset()(44);
        }
        
        self.startBtn.addTarget(self, action: #selector(startBtnClick(_ :)), for: .touchUpInside)
        
        
        
        self.view.addSubview(self.volumnView);
        
        self.volumnView.mas_makeConstraints { (make) in
            make?.edges.offset();
        }
        
        if #available(iOS 11.0, *) {
            if UIScreen.main.isCaptured {
                print("正在录制屏幕");
            } else
            {
                print("停止录屏！");
            }
        } else {
            // Fallback on earlier versions
        }
        
       
        if #available(iOS 11.0, *) {
            let routeView = AVRoutePickerView.init(frame: CGRect.init(x: 0, y: 100, width: 100, height: 100))
            routeView.delegate = self;
            self.view.addSubview(routeView);
        } else {
            // Fallback on earlier versions
        };

        // Do any additional setup after loading the view.
    }
    
    
    
    @objc
    private func audioRouteChanged(_ info: Notification) {
                
        print(info);
    }
    @objc
    private func startBtnClick(_ sender: UIButton) {
        
        if #available(iOS 11.0, *) {
            if UIScreen.main.isCaptured {
                
                DYNetworkHUD.showInfo(message: "当前正在进行屏幕录制", inView: self.view);
                return;
            }
        } else {
            // Fallback on earlier versions
        }
        
        
        
//        self.volumnView.mpBtn?.sendActions(for: .touchUpInside);
    
    }
    
    private lazy var startBtn: DYButton  = {
        
        let view = DYButton.init(type: .system);
        view.setTitle("开始投屏", for: .normal)
        view.setTitle("结束投屏", for: .selected)
        
        
        return view;
    }()

    
    private lazy var volumnView: DYVolumeView = {
        
        let view = DYVolumeView.init(frame: .zero);
        
        return view;
    }()
    
    
    deinit {
        NotificationCenter.default.removeObserver(self);
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


extension APHomeVC : AVRoutePickerViewDelegate {
    
    
    
    
}
