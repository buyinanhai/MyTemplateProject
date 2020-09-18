//
//  MyStudyCoinCell.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/9/14.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit
import DYTemplate
class MyStudyCoinCell: DYTableViewCell {

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        
        self.contentView.addSubview(self.dy_textLabel);
        self.contentView.addSubview(self.dy_detailTextLabel);
        self.contentView.addSubview(self.amountLabel);
        
        self.dy_textLabel.mas_makeConstraints { (make) in
            make?.top.offset()(20);
            make?.left.offset()(15);
            
        }
        self.dy_detailTextLabel.mas_makeConstraints { (make) in
            make?.left.offset()(15);
            make?.bottom.offset()(-15);
        }
        
        self.amountLabel.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(self.dy_textLabel);
            make?.right.offset()(-15);
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var model: AnyObject? {
        
        
        didSet {
            
            if let _model = self.model as? MyStudyCoinCellModel {
                self.dy_detailTextLabel.text = _model.time;
                self.amountLabel.text = "\(_model.amount ?? 0)";
                if _model.style == 0{
                    
                    self.amountLabel.textColor = UIColor.init(hexString: "#555555");
                    self.dy_textLabel.text = "购买课程";
                } else if _model.style == 1 {
                    
                    self.amountLabel.textColor = UIColor.init(hexString: "#F88832");
                    self.dy_textLabel.text = "充值金额";
                } else if _model.style == 2 {
                    
                    self.amountLabel.textColor = UIColor.init(hexString: "#53B17D");
                    self.dy_textLabel.text = "充值退款";
                }
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

    private lazy var amountLabel: UILabel = {
        
        let view = UILabel.init();
        view.font = UIFont.systemFont(ofSize: 16)
        
        return view;
    }()
    
    private lazy var dy_textLabel: UILabel = {
        
        let view = UILabel.init();
        view.font = UIFont.systemFont(ofSize: 16)
        view.textColor = UIColor.init(hexString: "#555555");
        
        return view;
    }()
    private lazy var dy_detailTextLabel: UILabel = {
        
        let view = UILabel.init();
        view.font = UIFont.systemFont(ofSize: 13)
        view.textColor = UIColor.init(hexString: "#979797");
        
        return view;
    }()
    
}
