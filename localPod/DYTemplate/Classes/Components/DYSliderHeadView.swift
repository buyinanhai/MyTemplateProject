//
//  DYSliderHeadView.swift
//  华商领袖
//
//  Created by hansen on 2019/5/5.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit



@objc public enum DYSliderHeaderType:Int {
    /// 固定title的宽度 根据内容宽度 决定是否可以滚动
    case normal
    /// 禁止滚动  平均分布
    case banScroll
    
}


@objcMembers class DYSliderModel {
    
    var title: String?
    var isSelect: Bool?
    var index: Int?
    var image: UIImage?
    
}
/**
 * 支持滑动的标题选择view
 */
@objc public enum DYButtonLayout: NSInteger {
    
    case imageBeLeft
    
    case imageBeTop
    
    case imageBeRight
    
    case imageLabelBeCenter
}

@objcMembers public class DYSliderHeadView: UIView {

    public var selectIndexBlock: ((_ index: Int) -> Void)?
   public var btnLayout: DYButtonLayout = .imageBeLeft;
   public var textColor: UIColor = UIColor.HWColorWithHexString(hex: "#333333");
   public var selectColor = UIColor.blue;
   public var currSelectIndex: Int = 0;
    ///滑动的线条宽度
   public var sliderLineWidth:CGFloat = 15;
   public var type: DYSliderHeaderType = .normal;
  public  var font: UIFont = UIFont.systemFont(ofSize: 14);
   public var imageSize: CGSize?
   public var images: [String]?
    ///view下面的黑线颜色
    public var lineColor:UIColor = UIColor.clear
    ///滑动的线条的颜色
  public  var sliderLineColor:UIColor = kDY_ThemeColor;
   public var sliderPositionX: CGFloat = 0.0 {
        
        didSet {
            self.slider.frame = CGRect.init(x: self.sliderPositionX, y: self.height - 2, width: self.slider.width, height: self.slider.height)
        }
    
    }
    private var titles: [String] {
        
        didSet {
            self.dataSources.removeAll();
            self.widthCache.removeAll();
            for item in self.titles {
                let index: Int = titles.firstIndex(of: item)!;
                let model = DYSliderModel.init();
                model.isSelect = index == self.currSelectIndex ? true : false;
                model.title = item;
                model.index = index;
                model.image = UIImage.init(named: item);
                if index < self.images?.count ?? 0 {
                    let imgstr = self.images?[index];
                    model.image = UIImage.init(named: imgstr ?? "");
                }
                var width = item.getTexWidth(font: self.font, height: 30) + 20;
                if width < 60 {
                    width  = 60;
                }
                self.widthCache[index] = width;
                self.dataSources.append(model);
            }
            if self.type == .banScroll {
                for (index,_) in self.dataSources.enumerated() {
                    let width = self.width / CGFloat(self.dataSources.count);
                    self.widthCache[index] = width;
                }
            }
            
        }
        
    }
    public required init(titles: [String]) {
        self.titles = titles;
        super.init(frame: CGRect.zero)
        
    }
    
  
    public override func layoutSubviews() {
        super.layoutSubviews();
        if self.subviews.count == 0 {
            self.setupSubview()
        }
    }
    private func setupSubview() {
       
        self.addSubview(self.collectionView)
        self.collectionView.mas_makeConstraints { (make) in
            make?.edges.offset()(0);
        }
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.addSubview(self.slider)
        if self.dataSources.count > 0 {
            self.slider.isHidden = false;
            
            self.slider.frame = CGRect.init(x: (self.widthCache[self.currSelectIndex]! - sliderLineWidth) * 0.5, y: self.height - 2, width: self.sliderLineWidth, height: 2);
        } else {
            self.slider.isHidden = true;
        }
        self.addSubview(self.lineView)
        self.lineView.mas_makeConstraints { (make) in
            make?.left.right().bottom()?.offset()(0);
            make?.height.offset()(1.0);
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
            self.updateSlider(index: self.currSelectIndex);
        });
     
    }
    
    public func updateTitles(_ titles: [String]) {
        
        self.titles = titles;
        self.collectionView.reloadData();
        if let cacheWidth = self.widthCache[self.currSelectIndex] {
            self.slider.frame = CGRect.init(x: (cacheWidth - sliderLineWidth) * 0.5, y: self.height - 2, width: self.sliderLineWidth, height: 2);
        }
        self.currSelectIndex = -1
        self.slider.isHidden = self.dataSources.count > 0 ? false : true;
        self.collectionView.scrollToItem(at: IndexPath.init(item: 0, section: 0), at: .centeredHorizontally, animated: true);
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.updateSlider(index: 0);
        }
        
    }
    
    func updateSelectIndexFromOther(_ index: Int) {
        if index == self.currSelectIndex {
            return;
        }
        
        if index > self.dataSources.count {
            return;
        }
        
        self.updateSlider(index: index);
        
    }
    
    public func hideBottomLine() {
        self.lineView.isHidden = true;
    }
//   设置固有的size  在nnavigation push pop的时候回联通这个view带上动画
    public override var intrinsicContentSize: CGSize {
        
        return self.bounds.size;
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var widthCache: [Int : CGFloat]  = [:];
    private lazy var slider: UIView = {
        let view = UIView()
        view.backgroundColor = .orange;
        view.bounds = CGRect.init(x: 0, y: 0, width: self.sliderLineWidth, height: 2);
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout.init();
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
    
        let view = UICollectionView.init(frame: CGRect.init(), collectionViewLayout: layout);
        view.backgroundColor = UIColor.white;
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell");
        view.showsHorizontalScrollIndicator = false;
        view.showsVerticalScrollIndicator = false;
        return view
    }()

    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = self.lineColor
        view.alpha = 0.5;
        return view
    }()
    private func updateSlider(index: Int) {
        if index == self.currSelectIndex || self.currSelectIndex >= self.titles.count { return}
        self.currentSelectModel?.isSelect = false;
        let beforeCell = self.collectionView.cellForItem(at: IndexPath.init(item: self.currSelectIndex, section: 0));
        if beforeCell != nil {
            
            if self.currSelectIndex < index {
                if index + 1 != self.titles.count {
                    
                    self.collectionView.scrollToItem(at: IndexPath.init(item: index + 1, section: 0), at: UICollectionView.ScrollPosition.right, animated: true);
                }
                
            } else {
                if index - 1 >= 0 {
                    self.collectionView.scrollToItem(at: IndexPath.init(item: index - 1, section: 0), at: UICollectionView.ScrollPosition.left, animated: true);
                }
                
            }
        }

        let cell = collectionView.cellForItem(at: IndexPath.init(item: index, section: 0));
      
        if let label = cell?.contentView.subviews.first as? DYButton {
            let model = self.dataSources[index];
            label.text = model.title;
            self.currSelectIndex = index;
            self.currentSelectModel?.isSelect = true;
            //        var x: CGFloat = CGFloat(index * self.widthCache[index]) + 15;
            var x: CGFloat = (self.widthCache[index]! - self.sliderLineWidth)  * 0.5;
            
            if index > 0 {
                for i in 0...index-1 {
                    if let width = self.widthCache[i] {
                        x += width;
                    }
                }
            }
            
            UIView.animate(withDuration: 0.25) {
                if let beforeView = beforeCell?.contentView.subviews.first as? DYButton {
                    self.updateLabelStatus(isSelect: false, label: beforeView);
                }
                self.updateLabelStatus(isSelect: true, label: label);
                self.slider.frame.origin.x = x;
            };
            
        }
       
    }
    
    private func updateLabelStatus(isSelect:Bool, label: DYButton) {
        let fontSize = self.font.pointSize ;
        label.titleLabel?.font = UIFont.systemFont(ofSize: isSelect ? fontSize + 2 : fontSize - 2);
        label.textColor = isSelect ? self.selectColor : self.textColor;
    }
    
    private var dataSources: [DYSliderModel] = []

    
    private var currentSelectModel: DYSliderModel? {
        
        get {
            
            return (self.dataSources.count > 0 && self.currSelectIndex > -1) ? self.dataSources[self.currSelectIndex] : nil;
        }
    }
    
    public override var backgroundColor: UIColor? {
        
        didSet {
            
            self.collectionView.backgroundColor = self.backgroundColor;
        }
        
    }

    
   

}

extension DYSliderHeadView: UICollectionViewDataSource, UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSources.count;
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let btn: DYButton?
        if cell.contentView.subviews.count == 0 {
            var dict = [DYButtonLayout.imageBeLeft : 0,DYButtonLayout.imageBeTop : 1,DYButtonLayout.imageBeRight : 2,DYButtonLayout.imageLabelBeCenter : 3];
            btn = DYButton.init();
            btn?.direction = ContentDirection(dict[self.btnLayout]!);
            btn?.textColor = self.textColor;
            btn?.titleLabel?.textAlignment = .center;
            btn?.titleLabel?.font = self.font;
            cell.contentView.addSubview(btn!);
            btn?.mas_makeConstraints({ (make) in
                make?.edges.offset();
            })
            btn?.isUserInteractionEnabled = false;
            
        } else {
            btn = cell.contentView.subviews.first as? DYButton
        }
       

        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let btn = cell.contentView.subviews.last as? DYButton {
            let model = self.dataSources[indexPath.item];
            if model.isSelect == true && indexPath.item == self.currSelectIndex {
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 16);
            } else {
                btn.titleLabel?.font = self.font;
            }
            btn.setTitleColor(model.isSelect == true ? self.selectColor : UIColor.HWColorWithHexString(hex: "#333333"), for: .normal);
            btn.setTitle(self.dataSources[indexPath.item].title, for: .normal);
            if self.imageSize?.width ?? 0 > 0 && self.imageSize?.height ?? 0 > 0 {
                btn.setImage(model.image?.resize(width: self.imageSize?.width ?? 0, height: self.imageSize?.height ?? 0), for: .normal);
                
            } else {
                btn.setImage(model.image, for: .normal);
            }
        }
        
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.updateSlider(index: indexPath.item);
        if self.selectIndexBlock != nil {
            self.selectIndexBlock!(indexPath.item);
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let cacheWidth = self.widthCache[indexPath.item] {
            return CGSize.init(width: cacheWidth, height: collectionView.height);
        }
        return CGSize.zero;
    }
    
}
