//
//  YZDTestRecordCell.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/7/14.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit

/**
 答题记录的cell
 */
class YZDTestRecordCell: DYTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override var model: AnyObject? {
        
        didSet {
            
            if let _model = model as? YZDTestRecordCellModel {
                
                self.nameLabel.text = _model.dy_classTypeName;
                self.timeLabel.text = Date.getFormdateMDHM(timeStamp: Double(_model.dy_createDate ?? 0));
//                let useTime = _model.dy_usedTime ?? 0;
//                self.consumeTimeLabel.text = String.init(format: "用时：%02d:%02d", useTime / 60, useTime % 60);
                self.chapterLabel.text = String.init(format: "%@ %@", _model.dy_moduleName ?? "" , _model.dy_lessonName ?? "");
                self.consumeTimeLabel.text = String.init(format: "用时：%02d分%02d秒", (_model.dy_usedTime ?? 0) / 60, (_model.dy_usedTime ?? 0) % 60);
                self.answeredLabel.text = "已做答：\(_model.dy_finishCount ?? 0)题";
                self.accuracyLabel.text = "正确率：\(_model.dy_accuracy ?? "0.0")%";
            }
            
        }
        
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupSubview();
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubview() {
        self.backgroundColor = .clear
        let subContentView = UIView.init();
        subContentView.backgroundColor = .clear;
        self.contentView.addSubview(subContentView);
        subContentView.mas_makeConstraints { (make) in
            make?.top.offset()(5);
            make?.left.offset()(10);
            make?.right.offset()(-10);
            make?.bottom.offset()(-5);
        }
        
        let imgView = UIImageView.init(image: UIImage.init(named: "yzd-test-record-cell"));
        subContentView.addSubview(imgView);
        subContentView.addSubview(self.timeLabel);
        subContentView.addSubview(self.nameLabel);
        subContentView.addSubview(self.chapterLabel);
        
        imgView.mas_makeConstraints { (make) in
            make?.edges.offset();
        }

        self.timeLabel.mas_makeConstraints { (make) in
            make?.right.offset()(-8);
            make?.centerY.equalTo()(self.nameLabel);
            make?.width.offset()(100);
        }
        self.nameLabel.mas_makeConstraints { (make) in
            make?.top.offset()(12);
            make?.left.offset()(10);
            make?.right.equalTo()(self.timeLabel.mas_left)?.offset()(-5);
        }
        self.chapterLabel.mas_makeConstraints { (make) in
            make?.centerY.offset();
            make?.left.equalTo()(self.nameLabel.mas_left);
            make?.right.offset()(-10);
        }
        
        
        let bottomView = UIView.init();
        
        subContentView.addSubview(bottomView);
        bottomView.mas_makeConstraints { (make) in
            make?.left.right()?.bottom()?.offset();
            make?.height.offset()(30);
        }
        bottomView.addSubview(self.consumeTimeLabel)
        bottomView.addSubview(self.answeredLabel);
        bottomView.addSubview(self.accuracyLabel);
        self.consumeTimeLabel.mas_makeConstraints { (make) in
            make?.centerY.offset();
            make?.left.offset()(5);
        }
        self.answeredLabel.mas_makeConstraints { (make) in
            make?.center.offset()
        }
        self.accuracyLabel.mas_makeConstraints { (make) in
            make?.right.offset()(-5);
            make?.centerY.offset();
        }
    }
    
    private lazy var timeLabel: UILabel = {
        
        let view = UILabel.init();
        view.font = .systemFont(ofSize: 11);
        view.text = "07月07日  11:30";
        view.textColor = .init(hexString: "#B9B9B9");
        view.textAlignment = .right;
        return view;
    }()

    private lazy var nameLabel: UILabel = {
        
        let view = UILabel.init();
        view.font = UIFont.boldSystemFont(ofSize: 15);
        view.textColor = UIColor.black;
        view.text = "六年级数学";
        
        return view;
    }()
    private lazy var chapterLabel: UILabel = {
        
        let view = UILabel.init();
        view.font = UIFont.systemFont(ofSize: 13);
        view.textColor = UIColor.gray;
        
        return view;
    }()
    
    private lazy var consumeTimeLabel: UILabel = {
        
        let view = UILabel.init();
        view.font = UIFont.systemFont(ofSize: 12)
        view.textColor = .init(hexString: "#B9B9B9")
        
        return view;
    }()
    private lazy var answeredLabel: UILabel = {
        
        let view = UILabel.init();
        view.font = UIFont.systemFont(ofSize: 12)
        view.textColor = .init(hexString: "#B9B9B9")
        
        return view;
    }()
    private lazy var accuracyLabel: UILabel = {
        
        let view = UILabel.init();
        view.font = UIFont.systemFont(ofSize: 12)
        view.textColor = .init(hexString: "#B9B9B9")
        
        return view;
    }()
}
