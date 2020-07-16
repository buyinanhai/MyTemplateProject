//
//  YZDHomeworkDetailHeaderView.swift
//  FXFSOnlineEdu
//
//  Created by 汪宁 on 2020/7/9.
//  Copyright © 2020 fwang. All rights reserved.
//

import UIKit

class YZDHomeworkDetailHeaderView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var myCollectionTopicBtn: DYButton!
    @IBOutlet weak var myErrorTpoicBtn: DYButton!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    class func initHeaderView() -> YZDHomeworkDetailHeaderView {
        
        let view = Bundle.main.loadNibNamed("YZDHomeworkDetailHeaderView", owner: nil, options: nil)?.last as! YZDHomeworkDetailHeaderView;
        
        view.subContent.addRound(10);
        
        return view;
    }
    @IBOutlet weak var subContent: UIView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
