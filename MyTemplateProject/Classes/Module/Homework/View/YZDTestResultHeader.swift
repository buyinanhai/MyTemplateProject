//
//  YZDTestResultHeader.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/7/14.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit

@objc
protocol YZDTestResultHeaderDelegate {
    
    @objc optional
    func headerView(_ view:YZDTestResultHeader, didSelected indexPath: IndexPath);
    func headerView(_ view:YZDTestResultHeader, onClickFolder isUnfold:Bool);
    
    
}

class YZDTestResultHeader: UIView {

    public var didSelectedCell: ((_ index: Int) -> Void)?
    
    public weak var delegate:YZDTestResultHeaderDelegate?
    
    
    @IBOutlet weak var titleBtn: UIButton!
    @IBOutlet weak var consumeTimeLabel: UILabel!
    @IBOutlet weak var answeredLabel: UILabel!
    @IBOutlet weak var accuracyLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    class func initHeaderView() -> YZDTestResultHeader {
        
            let view = Bundle.main.loadNibNamed("YZDTestResultHeader", owner: nil, options: nil)?.last as! YZDTestResultHeader;
        
        return view;
    }
    
    public func getHeight(for isUnfold: Bool) -> CGFloat {
    
        var height = self.height;
        let cellHeight:CGFloat = 60.0;
        var updateHeight = self.collectionView.contentSize.height - cellHeight;
        if self.collectionView.contentSize.height >= cellHeight * 4.0 {
            updateHeight = (cellHeight + 10.0) * 3.0 ;
        }
        
        height = isUnfold ? height + updateHeight : height - updateHeight;
    
        return height;
    }
    
    
    public func update(_ model: YZDTestResultDetailInfo, results: [Int : String]) {
        
        self.titleBtn.setTitle(model.dy_title, for: .normal);
        
        let timeStr = String.init(format: "%02d分 %02d秒", (model.dy_usedTime ?? 0) / 60, (model.dy_usedTime ?? 0) % 60);
        self.consumeTimeLabel.text = "用时：\(timeStr)";
        self.answeredLabel.text = "已作答：\(model.dy_finishCount ?? 0)";
        self.accuracyLabel.text = "正确率：\(model.dy_accuracy ?? "0.0")%";
        
        if let layout = self.collectionView.collectionViewLayout as? DYCollectionViewGridLayout {
            
            layout.pageCount = results.count;
            
        }
        self.results = results;
        self.collectionView.reloadData();
    }
    
   
    override func awakeFromNib() {
        super.awakeFromNib();
        self.setupSubview();
    }
  
    
    private func setupSubview() {
        let layout = DYCollectionViewGridLayout.init();
        layout.itemSize = CGSize.init(width: 40, height: 60);
        layout.rowCount = 5;
        layout.pageCount = 99999;
        self.collectionView.collectionViewLayout = layout;
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell");
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.isScrollEnabled = false;
    }
    
    
    @IBAction func downBtnClick(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected;
        
        sender.transform = sender.isSelected ? CGAffineTransform.init(rotationAngle: CGFloat(Double.pi)) : CGAffineTransform.identity;
        
        self.collectionView.isScrollEnabled = sender.isSelected;
        let newHeight = self.getHeight(for: sender.isSelected);
        var frame = self.frame;
        frame.size.height = newHeight;
        self.frame = frame;
        self.delegate?.headerView(self, onClickFolder: sender.isSelected);
        
        
    }
    
    private var results: [Int : String] = [:];
  
    
}
extension YZDTestResultHeader: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.results.count;
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
            btn?.margin = 10;
            btn?.frame = cell.contentView.bounds;
            btn?.isEnabled = false;
            btn?.titleLabel?.font = .systemFont(ofSize: 15);
            btn?.setTitleColor(.init(hexString: "#555555"), for: .normal);

        }
        
        let imgs = ["0":"yzd-homework-result-error","1":"yzd-homework-result-correct","-1":"yzd-homework-result-unanswer"];
        if let result = self.results[indexPath.row], let img = imgs[result] {
            btn?.setImage(UIImage.init(named: img), for: .normal)
        }
        btn?.setTitle("\(indexPath.row + 1)", for: .normal);

        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.didSelectedCell?(indexPath.row);
        
    }
    
    
    
}

