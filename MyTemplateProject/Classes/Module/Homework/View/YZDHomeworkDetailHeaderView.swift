//
//  YZDHomeworkDetailHeaderView.swift
//  FXFSOnlineEdu
//
//  Created by 汪宁 on 2020/7/9.
//  Copyright © 2020 fwang. All rights reserved.
//

import UIKit

class YZDHomeworkDetailHeaderViewModel: NSObject {
    
    /*
     
     "name":"第三方的士大夫",                //类型：String  必有字段  备注：课程名称
     "finishCount":11,                //类型：Number  必有字段  备注：已完成题量
     "accuracy":"90.9",                //类型：String  必有字段  备注：正确率
     "questionCount":28
     */
    var name: String?
    var finishCount: Int?
    var accuracy: String?
    var questionCount: Int?

    
    class func modelWithDict(_ dict: [String : Any]) -> YZDHomeworkDetailHeaderViewModel {
        
        let model = YZDHomeworkDetailHeaderViewModel.init();
        model.name = dict["name"] as? String;
        model.questionCount = dict["questionCount"] as? Int;
        model.finishCount = dict["finishCount"] as? Int;
        model.accuracy = dict["accuracy"] as? String;
        return model;
    }
}

class YZDHomeworkDetailHeaderView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var acountLabel: UILabel!
    @IBOutlet weak var finishedCount: UILabel!
    
    @IBOutlet weak var accuracyLabel: UILabel!
    public var model: YZDHomeworkDetailHeaderViewModel? {
        
        didSet {
            
            if let value = self.model {
                
                self.acountLabel.text = "题量：\(value.questionCount ?? 0)";
                self.finishedCount.text = "已完成：\(value.finishCount ?? 0)";
                self.accuracyLabel.text = "正确率：\(value.accuracy ?? "0.0")%";
                if let accuracy = value.accuracy {
                    if accuracy == "-1" {
                        self.accuracyLabel.text = "正确率：未作答";
                    } else {
                        self.accuracyLabel.text = "正确率：\(accuracy)%";
                    }
                }
            }
            
        }
        
    }
    
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
