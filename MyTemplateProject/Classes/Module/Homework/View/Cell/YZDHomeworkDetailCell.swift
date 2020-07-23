//
//  YZDHomeworkDetailCell.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/7/13.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit


/**
 选择作业的cell
 */
class YZDHomeworkDetailCell: UITableViewCell {

    public var stateBtnClickCallback: ( ( YZDHomeworkChapterSectionModel_afterWorks?) -> Void)?

    
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
    
    public var model: Any? {
        
        didSet {
            
            self.stackView.removeChildViews();
            guard let _model = model as? YZDHomeworkChapterSectionModel else {
                return
            }
            self.nameLabel.text = _model.dy_lessonName;
            if _model.dy_afterWorks?.count == 0 {
                self.stackView.removeFromSuperview();
            } else {
                if let contentView = self.stackView.superview {
                    contentView.addSubview(self.stackView);
                    self.stackView.mas_makeConstraints { (make) in
                        make?.top.equalTo()(self.nameLabel.mas_bottom)?.offset()(8);
                        make?.left.right()?.bottom()?.offset();
                    }
                    for item in _model.dy_afterWorks ?? [] {
                        let view = YZDHomeworkDetailCellSubview.init()
                        view.model = item;
                        view.stateBtnClickCallback = {
                            [weak self] (model) in
                            self?.stateBtnClickCallback?(model);
                        };
                        self.stackView.addArrangedSubview(view);
                    }
                }
            }
           
          
            
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubview() {
        self.backgroundColor = .clear
        let subContentView = UIView.init(frame: .init(x: 0, y: 0, width: 200, height: 100));
        subContentView.addRound(10);
        subContentView.backgroundColor = .white;
        self.contentView.addSubview(subContentView);
        subContentView.mas_makeConstraints { (make) in
            make?.left.offset()(15);
            make?.right.offset()(-15);
            make?.top.offset()(7.5);
            make?.bottom.offset()(-7.5);
        }
        
        subContentView.addSubview(self.nameLabel);
        subContentView.addSubview(self.stackView);
        
        self.nameLabel.mas_makeConstraints { (make) in
            make?.top.offset()(10);
            make?.left.offset()(30);
            make?.height.offset()(30);
            make?.right.offset()(-5);
        }
        self.stackView.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.nameLabel.mas_bottom)?.offset()(8);
            make?.left.right()?.bottom()?.offset();
        }
        
        
    }
    
    private lazy var nameLabel: UILabel = {
        
        let view = UILabel.init()
        view.font = UIFont.boldSystemFont(ofSize: 14)
        view.textColor = UIColor.HWColorWithHexString(hex: "#4C4D50")
        view.text = "小节名称";
        return view;
    }()
    
    private lazy var stackView: UIStackView = {
        
        let view = UIStackView.init(frame: .init(x: 0, y: 0, width: 200, height: 50));
        view.axis = .vertical;
        view.distribution = .fillEqually
        return view;
        
    }()
    
    
    
    
    

}

fileprivate class YZDHomeworkDetailCellSubview: UIView {
    
    
    public var stateBtnClickCallback: ( ( YZDHomeworkChapterSectionModel_afterWorks?) -> Void)?
    
    
    public var model: YZDHomeworkChapterSectionModel_afterWorks? {
        
        didSet {
            
            self.detailLabel.text = "题量：\(self.model?.dy_questionCount ?? 0)  已完成：\(self.model?.dy_finishCount ?? 0)         正确率：\(self.model?.dy_accuracy ?? "0.0")%";
            self.nameLabel.text = self.model?.dy_title;
            let homeworkState = self.model?.dy_isBegin ?? -1;
            if homeworkState > -1 {
                let stateUI = self.states[homeworkState];
                self.stateBtn.setTitle(stateUI.2, for: .normal);
                self.stateBtn.setBackgroundImage(UIImage.init(named: stateUI.0), for: .normal);
                self.stateBtn.setTitleColor(.init(hexString: stateUI.1), for: .normal);
            }
            
        }
        
    }
    
    init() {
        
        super.init(frame: .zero);
        
        self.setupSubview()
    }
    
    private func setupSubview() {
        
        self.addSubview(self.icon);
        self.addSubview(self.nameLabel)
        self.addSubview(self.detailLabel)
        self.addSubview(self.stateBtn);
        
        self.icon.mas_makeConstraints { (make) in
            make?.left.offset()(8);
            make?.top.offset()(8);
            make?.size.offset()(15);
        }
        self.nameLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(self.icon.mas_right)?.offset()(8);
            make?.centerY.equalTo()(self.icon);
            make?.right.equalTo()(self.stateBtn.mas_left);
            
        }
        self.stateBtn.mas_makeConstraints { (make) in
            make?.right.offset()(-5);
            make?.width.offset()(72);
            make?.height.offset()(28);
            make?.centerY.equalTo()(self.nameLabel);
        }
        
        self.detailLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(self.nameLabel);
            make?.bottom.offset()(-5);
        }
        self.stateBtn.addTarget(self, action: #selector(stateBtnClick), for: .touchUpInside);
        
        
    }
    
    @objc
    private func stateBtnClick() {
        
        self.stateBtnClickCallback?(self.model);
        
    }
    
    required init?(coder: NSCoder) {
        fatalError();
    }
    
    
    
    private lazy var icon: UIImageView = {
        
        let view = UIImageView.init();
        view.image = UIImage.init(named: "yzd-class-after");
        
        return view;
    }()
    
    private lazy var nameLabel: UILabel = {
        
        let view = UILabel.init();
        view.font = UIFont.systemFont(ofSize: 13);
        view.textColor = UIColor.HWColorWithHexString(hex: "#4C4D50");
        view.text = "课程练习名称";
        return view;
    }()
    
    private lazy var detailLabel: UILabel = {
        
        let view = UILabel.init();
        view.font = UIFont.systemFont(ofSize: 12);
        view.textColor = UIColor.HWColorWithHexString(hex: "#B9B9B9");
        view.text = "题量：  已完成：  正确率： ";
        
        return view;
    }()
    
    private lazy var stateBtn: UIButton = {
        
        let view = UIButton.init();
        
        let tuple = self.states[0];
        
        view.setBackgroundImage(UIImage.init(named: tuple.0), for: .normal);
        view.setTitleColor(.HWColorWithHexString(hex: tuple.1), for: .normal);
        view.setTitle("课前练习", for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 13)

        return view;
    }()
    
    private var states: [(String,String, String)] {
        
        get {
            return [
                ("yzd-class-practise-continue","#3793E8", "继续作业"),
                ("yzd-class-practise-again","#2B44AD","再做一次"),
                ("yzd-class-practise-start","#F0792D","开始作业"),
            ]
        }
    }
    
    
}
