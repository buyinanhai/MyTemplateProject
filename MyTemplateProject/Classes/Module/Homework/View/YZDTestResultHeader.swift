//
//  YZDTestResultHeader.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/7/14.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit

class YZDTestResultHeader: UIView {

    public var didSelectedCell: ((_ index: Int) -> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.setupSubview();
    }
    
    private func setupSubview() {
        
        self.addSubview(self.titleLabel);
        self.addSubview(self.detailLabel);
        self.addSubview(self.collectionView);
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.titleLabel.mas_makeConstraints { (make) in
            make?.left.top()?.offset()(8);
        }
        self.detailLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(self.titleLabel);
            make?.top.equalTo()(self.titleLabel.mas_bottom)?.offset()(15);
            make?.right.offset();
        }
        self.collectionView.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.detailLabel.mas_bottom)
            make?.left.right()?.bottom()?.offset();
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private lazy var titleLabel: UILabel = {
        
        let view = UILabel.init();
        view.font = .boldSystemFont(ofSize: 16);
        view.textColor  = UIColor.black;
        view.text = "课后练习";
        
        return view;
    }()
    
    private lazy var detailLabel: UILabel = {
        
        let view = UILabel.init();
        view.font = .systemFont(ofSize: 15)
        view.textColor = .black;
        view.text = "用时：2分30秒   已做答：5题    正确率：66%";
        
        return view;
    }()
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = DYCollectionViewGridLayout.init();
        layout.itemSize = CGSize.init(width: 40, height: 80);
        layout.rowCount = 5;
        layout.pageCount = 20;
        let view =  UICollectionView.init(frame: .zero, collectionViewLayout: layout);
        view.backgroundColor = .white;
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell");
        
        return view;
    }()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
extension YZDTestResultHeader: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 20;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath);
        
        var btn = cell.contentView.subviews.first as? DYButton;
        
        if btn  == nil {
            btn = DYButton.init(type: .custom);
            btn?.direction = 1;
            let image = UIImage.init(color: .red)
            btn?.setImage(image, for: .normal);
            cell.contentView.addSubview(btn!);
            btn?.textColor = .black;
            btn?.frame = cell.contentView.bounds;
            btn?.isEnabled = false;
        }
        btn?.setTitle("\(indexPath.row + 1)", for: .normal);

        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.didSelectedCell?(indexPath.row);
        
    }
    
    
}

