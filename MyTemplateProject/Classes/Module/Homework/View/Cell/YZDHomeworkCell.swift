//
//  YZDHomeworkCell.swift
//  FXFSOnlineEdu
//
//  Created by 汪宁 on 2020/7/9.
//  Copyright © 2020 fwang. All rights reserved.
//

import UIKit

class YZDHomeworkCell: DYTableViewCell {

    
    override var model: AnyObject? {
        
        didSet {
            if let value = self.model as? YZDHomeworkModel {
                
                self.titleLabel.text = value.homeworkName;
                self.topicLabel.text = "题量：\(value.topicCount ?? "0")   正确率：\(value.accuracy ?? "未做题")"
//                sd_loadingImg(value.icon ?? "", iv: self.iconView, defImgName: "00000000006")
                self.iconView.dy_setImage(urlStr: value.icon ?? "", placeholder: UIImage.init(named: "00000000006"));
            }
            
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.setupSubview();
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupSubview() {
        
        self.backgroundColor = UIColor.clear;
        let subContentView = UIView.init(frame: .zero);
        subContentView.backgroundColor = .white;
        self.contentView.addSubview(subContentView);
        self.subContentView = subContentView;
        subContentView.mas_makeConstraints { (make) in
            make?.left.top()?.offset()(15);
            make?.right.bottom()?.offset()(-15);
        }
        
        subContentView.addSubview(self.titleLabel)
        subContentView.addSubview(self.iconView);
        subContentView.addSubview(self.topicLabel);
        
        self.titleLabel.mas_makeConstraints { (make) in
            
            make?.left.top()?.offset()(5);
            make?.right.equalTo()(self.iconView.mas_left)
        }
        self.iconView.mas_makeConstraints { (make) in
            
            make?.right.bottom()?.offset()(-5);
            make?.width.offset()(120);
            make?.top.offset()(5);
        }
        self.topicLabel.mas_makeConstraints { (make) in
            
            make?.left.offset()(5);
            make?.right.equalTo()(self.iconView.mas_left);
            make?.bottom.offset()(-5);
        }
        self.subContentView.addRound(5)
        self.iconView.addRound(8)
       
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
    }
    
    private lazy var titleLabel: UILabel = {
        
        let label = UILabel.init()
        label.textColor = UIColor.HWColorWithHexString(hex: "#2A2B30");
        label.font = UIFont.boldSystemFont(ofSize: 15);
        label.numberOfLines = 2;
        label.text = "作业名称"
        return label;
        
    }()
    
    private var subContentView: UIView!
    
    
    private lazy var  iconView: UIImageView = {
        
        let view = UIImageView.init(frame: .zero)
        view.image = UIImage.init(named: "00000000006")
        
        return view;
        
    }()
    
    private lazy var topicLabel: UILabel = {
        
        let view = UILabel.init()
        view.textColor = UIColor.HWColorWithHexString(hex: "#B9B9B9");
        view.font = UIFont.boldSystemFont(ofSize: 11);
        view.text = "题量：  正确率：";
        view.textAlignment = .left;
        return view;
    }()
    
  
}
