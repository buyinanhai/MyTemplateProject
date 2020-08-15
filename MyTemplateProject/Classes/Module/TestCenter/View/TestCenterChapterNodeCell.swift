//
//  TestCenterChapterNodeCell.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/8/13.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit
import DYTemplate.DYTableView

protocol TestCenterChapterNodeCellDelegate: NSObject {
    
    
    func onClickFolderBtn(model:TestCenterNodeModel ,isSelectd: Bool);
    
    func onClickStartBtn(model:TestCenterNodeModel);
    
}

class TestCenterChapterNodeCell: DYTableViewCell  {

    
    weak public var delegate: TestCenterChapterNodeCellDelegate?
    
    override var model: AnyObject? {
        
        didSet {
                   
            if let value = self.model as? TestCenterNodeModel {
                
                self.folderBtn.isSelected = value.dy_isUnfold;
                self.nameLabel.text = value.dy_title;
                self.detailNodeLabel.text = "已做题 \(value.dy_finishCount ?? 0)/\(value.dy_totalCount ?? 0)";
                let marginLeft = self.width * 0.08;
                self.folderBtn.mas_updateConstraints { (make) in
                    
                    let moveMargin = marginLeft * CGFloat((value.dy_level - 1)) + 15;
                    make?.left.offset()(moveMargin);
                }
                self.folderBtn.isHidden = (value.dy_children?.count == 0 || value.dy_children == nil) ? true : false;
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
        
        self.contentView.addSubview(self.folderBtn);
        self.contentView.addSubview(self.nameLabel);
        self.contentView.addSubview(self.detailNodeLabel);
        self.contentView.addSubview(self.startBtn);
        
        self.folderBtn.mas_makeConstraints { (make) in
            make?.centerY.offset();
            make?.left.offset()(15);
            make?.size.offset()(35);
        }

        self.nameLabel.mas_makeConstraints { (make) in
            make?.bottom.equalTo()(self.folderBtn.mas_centerY)?.offset()(-2.5);
            make?.left.equalTo()(self.folderBtn.mas_right)?.offset()(10);
            make?.right.equalTo()(self.startBtn.mas_left);
            
        }
        
        self.detailNodeLabel.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.nameLabel.mas_bottom)?.offset()(5);
            make?.left.equalTo()(self.folderBtn.mas_right)?.offset()(10);
            make?.right.equalTo()(self.startBtn.mas_left);
            
        }
        self.startBtn.mas_makeConstraints { (make) in
            make?.centerY.offset();
            make?.right.offset()(-15);
            make?.size.offset()(35);
        }
        
        self.folderBtn.addTarget(self, action: #selector(onFoldBtnClick(_ :)), for: .touchUpInside);
        self.startBtn.addTarget(self, action: #selector(startBtnClick), for: .touchUpInside)
    }
    
    @objc
    private func onFoldBtnClick(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected;
        (self.model as? TestCenterNodeModel)?.dy_isUnfold = sender.isSelected;
        self.delegate?.onClickFolderBtn(model: self.model as! TestCenterNodeModel, isSelectd: sender.isSelected);
        self.otherClickFlag?(self.model as Any, 1001);
    }
    @objc
    private func startBtnClick() {
        
        self.delegate?.onClickStartBtn(model: self.model as! TestCenterNodeModel);
        self.otherClickFlag?(self.model as Any, 1002);

    }
    
    private lazy var folderBtn: UIButton = {
        
        let view = UIButton.init();
        view.setImage(UIImage.init(named: "tc-choose-unfold"), for: .normal);
        view.setImage(UIImage.init(named: "tc-choose-fold"), for: .selected);

        return view;
    }()
    
    private lazy var nameLabel: UILabel = {
        
        let view = UILabel.init();
        view.textColor = .init(hexString: "#333333");
        view.font = .boldSystemFont(ofSize: 15.2);
        
        return view;
    }()

    private lazy var detailNodeLabel: UILabel = {
        
        let view = UILabel.init();
        view.textColor = .init(hexString: "#B9B9B9");
        view.font = .systemFont(ofSize: 11);
        
        return view;
    }()
    
    private lazy var startBtn: UIButton = {
        
        let view = UIButton.init();
        view.setImage(UIImage.init(named: "tc-choose-start"), for: .normal);
        return view;
    }()
}
