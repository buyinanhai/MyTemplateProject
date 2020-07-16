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
        subContentView.backgroundColor = .white;
        self.contentView.addSubview(subContentView);
        subContentView.mas_makeConstraints { (make) in
            make?.top.offset()(5);
            make?.left.right()?.bottom()?.offset();
        }
        
        subContentView.addSubview(self.timeLabel);
        subContentView.addSubview(self.nameLabel);
        subContentView.addSubview(self.chapterLabel);
        subContentView.addSubview(self.descLabel);

        self.timeLabel.mas_makeConstraints { (make) in
            make?.top.left()?.offset()(8);
        }
        self.nameLabel.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.timeLabel.mas_bottom)?.offset()(8);
            make?.left.equalTo()(self.timeLabel.mas_left);
            make?.right.offset()(-10);
        }
        self.chapterLabel.mas_makeConstraints { (make) in
                   make?.top.equalTo()(self.nameLabel.mas_bottom)?.offset()(8);
                   make?.left.equalTo()(self.timeLabel.mas_left);
                   make?.right.offset()(-10);
               }
        self.descLabel.mas_makeConstraints { (make) in
                   
            make?.left.equalTo()(self.timeLabel.mas_left);
            make?.right.offset()(-10);
            make?.bottom.offset();
            
               }
        
    }
    
    private lazy var timeLabel: UILabel = {
        
        let view = UILabel.init();
        view.font = .systemFont(ofSize: 13);
        view.text = "07月07日  11:30";
        view.textColor = .lightGray;
        
        return view;
    }()

    private lazy var nameLabel: UILabel = {
        
        let view = UILabel.init();
        view.font = UIFont.boldSystemFont(ofSize: 16);
        view.textColor = UIColor.black;
        view.text = "六年级数学";
        
        return view;
    }()
    private lazy var chapterLabel: UILabel = {
        
        let view = UILabel.init();
        view.font = UIFont.systemFont(ofSize: 14);
        view.textColor = UIColor.gray;
        view.text = "第一单元  老茶馆 第一节 光头强";
        
        return view;
    }()
    private lazy var descLabel: UILabel = {
        
        let view = UILabel.init();
        view.font = .systemFont(ofSize: 15)
        view.textColor = .black;
        view.text = "用时：2分30秒   已做答：5题    正确率：66%";
        return view;
    }()
}
