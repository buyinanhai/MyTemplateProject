//
//  TestCenterHeaderView.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/8/7.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit
import DYTemplate

protocol TestCenterHeaderViewDelegate {
    
    func onClickChooseBtn();
    
    func onShowSearchVC();
}

class TestCenterHeaderView: UIView {

    public var delegate: TestCenterHeaderViewDelegate?
    public weak var titleLabel: UILabel!;
    public weak var progressLabel: UILabel!
    public weak var subjectLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = .init(hexString: "#F7F7F7");
        self.addSubview(self.searchHeader);
        self.searchHeader.mas_makeConstraints { (make) in
            make?.left.offset()(15);
            make?.right.offset()(-15);
            make?.height.offset()(64);
            make?.top.offset();
        }
        let subContentView = UIView.init();
        subContentView.addRound(5)
        self.addSubview(subContentView);
        subContentView.mas_makeConstraints { (make) in
            make?.width.equalTo()(self.searchHeader);
            make?.top.equalTo()(self.searchHeader.mas_bottom);
            make?.height.offset()(108);
            make?.centerX.offset();
        }
        
        let imgV = UIImageView.init(image: UIImage.init(named: "tc-choose-header-bg"));
        
        subContentView.addSubview(imgV);
        imgV.mas_makeConstraints { (make) in
            make?.edges.offset();
        }
        
        let titleLabel = UILabel.init();
        titleLabel.backgroundColor = .init(hexString: "#FFE7CA");
        titleLabel.textColor = .init(hexString: "#FC9329");
        titleLabel.addRound(5.0);
        titleLabel.font = .systemFont(ofSize: 15);
        titleLabel.text = " 知识点做题 ";
        
        let subjectLabel = UILabel.init();
        subjectLabel.textColor = .init(hexString: "#FFB366");
        subjectLabel.font = .systemFont(ofSize: 11);
        subjectLabel.text = "高中-数学-人教版-必修一";
        subjectLabel.numberOfLines = 2;
        
        let finishedLabel = UILabel.init();
        finishedLabel.textColor = .init(hexString: "#FFB366");
        finishedLabel.font = .systemFont(ofSize: 11);
        finishedLabel.text = "已做题0/0";
        
        subContentView.addSubview(titleLabel);
        subContentView.addSubview(subjectLabel);
        subContentView.addSubview(finishedLabel);
        subContentView.addSubview(self.chooseBtn);

        titleLabel.mas_makeConstraints { (make) in
            make?.top.left()?.offset()(10);
            
        }
        subjectLabel.mas_makeConstraints { (make) in
            make?.centerY.offset();
            make?.left.offset()(10);
            make?.right.equalTo()(self.chooseBtn.mas_left);
            
        }
        finishedLabel.mas_makeConstraints { (make) in
            make?.left.offset()(10);
            make?.bottom.offset()(-15);
        }
        self.chooseBtn.mas_makeConstraints { (make) in
            make?.centerY.offset();
            make?.right.offset()(-20);
            make?.width.offset()(35);
            make?.height.offset()(60);
        }
        
        self.titleLabel = titleLabel;
        self.progressLabel = finishedLabel;
        self.subjectLabel = subjectLabel;
        
        self.chooseBtn.addTarget(self, action: #selector(chooseBtnClick), for: .touchUpInside);
        self.searchHeader.addTarget(self, selector: #selector(searchBtnClick));
    }
    
    
    @objc
    private func searchBtnClick() {
        
        self.delegate?.onShowSearchVC()
    }
    
    
    @objc
    private func chooseBtnClick() {
        
        self.delegate?.onClickChooseBtn();
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private lazy var searchHeader: UIView = {
        
        let view = UIView.init();
        view.backgroundColor = .clear;
        
        let placeView = UILabel.init();
        placeView.backgroundColor = UIColor.white;
        placeView.addRound(10);
        placeView.text = "   请输入关键词搜索知识点";
        placeView.textColor = .init(hexString: "#BBBBBB")
        placeView.font = .systemFont(ofSize: 13);
        view.addSubview(placeView);
        
        let searchBtn = UIButton.init();
        searchBtn.setImage(UIImage.init(named: "yzd-homework-search"), for: .normal);
        searchBtn.isUserInteractionEnabled = true;
        searchBtn.setBackgroundImage(UIImage.init(named: "yzd-homework-search-bg"), for: .normal);
        searchBtn.tag = 1001;
        view.addSubview(searchBtn);
        searchBtn.mas_makeConstraints { (make) in
            make?.right.offset()(-15);
            make?.left.equalTo()(placeView.mas_right);
            make?.width.offset()(49);
            make?.height.offset()(33);
            make?.top.offset()(15);
        }
        placeView.mas_makeConstraints { (make) in
            make?.left.top()?.offset()(15);
            make?.right.equalTo()(searchBtn.mas_left)?.offset()(10);
            make?.height.offset()(33);
        }
        
        
        return view;
    }()
    
    private lazy var chooseBtn:DYButton  = {
        
        let view = DYButton.init();
    
        view.direction = 1;
        view.setTitle("选题", for: .normal);
        view.setImage(UIImage.init(named: "TC-choose-test"), for: .normal);
        view.titleLabel?.font = .systemFont(ofSize: 15);
        view.setTitleColor(.init(hexString: "#FC952C"), for: .normal);
        view.sizeToFit();
        return view;
    }()
}
