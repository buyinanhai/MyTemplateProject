//
//  DYVolumeView.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/8/15.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit
class DYVolumeView: MPVolumeView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    public var mpBtn: UIButton?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.backgroundColor = .clear;
        self.showsVolumeSlider = false;
        self.initMpButton();
        
                
        
        
    }
    
    
    private func initMpButton() {
        
        for item in self.subviews {
            
            if let btn = item as? UIButton {
                
//                btn.setImage(nil, for: .normal);
//
//                btn.setImage(nil, for: .selected);
//                btn.setImage(nil, for: .highlighted)
                btn.bounds = .zero;
                self.mpBtn = btn;
                break;
            }
        }
        
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
