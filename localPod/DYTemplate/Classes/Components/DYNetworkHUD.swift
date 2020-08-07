//
//  DYNetworkHUD.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/7/20.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit

@objcMembers public class DYNetworkHUD: NSObject {

    
    //MARK: public
    
    public static let shared: DYNetworkHUD = DYNetworkHUD.init();
    
    public var showTime: Double = 2.0;
    
    public class func startLoading() {
        
        let hud = DYNetworkHUD.shared;
        
        if !hud.activityView.isAnimating {
            hud.defaultShowView?.addSubview(hud.activityView);
            hud.activityView.mas_makeConstraints { (make) in
                make?.center.offset();
            }
        }
        
        hud.activityView.startAnimating();
        
    }
    public class func dismiss() {
        
        let hud = DYNetworkHUD.shared;
        hud.activityView.stopAnimating();
        hud.activityView.removeFromSuperview();
        
    }
    
    public class func showInfo(message: String, inView: UIView?) {
       
        let hud = DYNetworkHUD.shared;

        if hud.activityView.isAnimating {
            hud.activityView.stopAnimating();
            hud.activityView.removeFromSuperview()
        }
        hud.inView = inView;
        if hud.inView == nil {
            hud.inView = UIApplication.shared.windows.first;
        }
        hud.messageView.text = "   " + message + "   ";
        hud.inView?.addSubview(hud.messageView);
        hud.messageView.mas_makeConstraints { (make) in
            make?.center.offset();
            make?.height.lessThanOrEqualTo()(hud.inView);
            make?.width.lessThanOrEqualTo()(hud.inView)
//            make?.width.offset()(120);
//            make?.height.offset()(60);
        }
       
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + hud.showTime) {
            hud.messageView.removeFromSuperview();
        }
        
    }
    
    
    //MARK: privte
    
    private override init() {
    
        
    }
    
    private var defaultShowView: UIView? {
        
        get {
            
            return UIApplication.shared.windows.first;
            
        }
        
    }
    
    
    private lazy var activityView: UIActivityIndicatorView = {
        
        let view = UIActivityIndicatorView.init();
        if #available(iOS 13.0, *) {
            view.style = .large
        } else {
            // Fallback on earlier versions
            view.style = .whiteLarge;
        };
        view.color = .gray;
        
        return view;
    }()
    
    private lazy var messageView: UILabel = {
        
        let view = UILabel.init();
        view.backgroundColor = .black;
        view.font = UIFont.systemFont(ofSize: 14);
        view.textAlignment = .center;
        view.numberOfLines = 0;
        view.layer.cornerRadius = 5;
        view.clipsToBounds = true;
        view.textColor = .white;
        return view;
    }()
    
    
    private var inView: UIView?
    
}
