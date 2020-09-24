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
        
        if !hud.progressView.isAnimating {
            hud.shelterView.isHidden = false;
            hud.defaultShowView?.addSubview(hud.progressView);
            hud.progressView.mas_makeConstraints { (make) in
                make?.center.offset();
                make?.size.offset()(120);
            }
        }
        
        hud.progressView.startAnimating();
        
    }
    public class func dismiss() {
        
        let hud = DYNetworkHUD.shared;
        hud.progressView.stopAnimating();
        hud.progressView.removeFromSuperview();
        hud.shelterView.isHidden = true;

    }
    
    public class func showInfo(message: String, inView: UIView? = nil) {
       
        let hud = DYNetworkHUD.shared;

        if hud.progressView.isAnimating {
            hud.progressView.stopAnimating();
            hud.progressView.removeFromSuperview()
            hud.shelterView.isHidden = true;
        }
        hud.inView = inView;
        if hud.inView == nil {
            hud.inView = UIApplication.shared.windows.first;
        }
        hud.messageView.text =  message ;
        hud.inView?.addSubview(hud.messageView);
        hud.messageView.mas_makeConstraints { (make) in
            make?.bottom.offset()(-64);
            make?.centerX.offset();
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
    
        super.init();
        
        self.defaultShowView?.addSubview(self.shelterView);
        self.shelterView.mas_makeConstraints { (make) in
            make?.edges.offset();
        }
    }
    
    private var defaultShowView: UIView? {
        
        get {
            
            return UIApplication.shared.windows.first;
            
        }
        
    }
    
    
    private lazy var messageView: DYNetworkMessageView = {
        
        let view = DYNetworkMessageView.init();
        
        return view;
    }()
    
    
    private var inView: UIView?
    private var progressView: DYNetworkProgressView = {
        
        let view = DYNetworkProgressView.init(frame: .zero);
        
        return view;
    }()
    private lazy var shelterView: UIView = {
        
        let view = UIView.init();
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.3);
        
        return view;
    }()
    
}
    
   
    
private class DYNetworkMessageView: UIView {
    
    public var text: String? {
        
        didSet {
            
            self.label.text = text;
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.addSubview(self.label);
        self.label.mas_makeConstraints { (make) in
            make?.left.top()?.offset()(5);
            make?.right.bottom()?.offset()(-5);
        }
        self.layer.cornerRadius = 5;
        self.clipsToBounds = true;
        self.backgroundColor = .black;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        
        return CGSize.init(width: 120, height: 40);
    }
    
    private lazy var label: UILabel = {
        
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
    
}

private class DYNetworkProgressView: UIView {
    
    public var isAnimating: Bool {
        
        return self.activityView.isAnimating;
    }

    public func startAnimating() {
        
        self.activityView.startAnimating()
    }
    public func stopAnimating() {
        self.activityView.stopAnimating();
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        let effect = UIBlurEffect.init(style: .dark)
        let effectView = UIVisualEffectView.init(effect: effect);
        self.insertSubview(effectView, at: 0);
        effectView.frame = self.bounds;
        effectView.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleWidth];
        self.backgroundColor = UIColor.black;
        self.layer.allowsGroupOpacity = false;
        
        self.addSubview(self.activityView);
        self.activityView.mas_makeConstraints { (make) in
            make?.center.offset();
        }
        self.layer.cornerRadius = 8;
        self.clipsToBounds = true;
    }
    
    
    private lazy var activityView: UIActivityIndicatorView = {
        
        let view = UIActivityIndicatorView.init();
        if #available(iOS 13.0, *) {
            view.style = .large
        } else {
            // Fallback on earlier versions
            view.style = .whiteLarge;
        };
        view.color = .white;
        
        return view;
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
