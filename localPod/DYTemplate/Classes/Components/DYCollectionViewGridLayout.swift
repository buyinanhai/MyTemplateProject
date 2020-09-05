//
//  DYCollectionViewGridLayout.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/7/14.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit
@objcMembers public class DYCollectionViewGridLayout: UICollectionViewLayout {

    public var itemSize: CGSize!;
    
    /// 每页数量
    public var pageCount: Int!
    ///每行数量
    public var rowCount: Int!;
    
    //    var horizontalMargin: CGFloat! = 8;
    
    public var verticalMargin: CGFloat! = 8
    
    public override func prepare() {
        super.prepare();
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var arrayM: [UICollectionViewLayoutAttributes] = [];
        let maxCount = self.collectionView?.numberOfItems(inSection: 0) ?? 0;
        
        for index in 0..<maxCount {
            let indexPath = IndexPath.init(item: index, section: 0);
            let attributtes = self.layoutAttributesForItem(at: indexPath);
            if let _value = attributtes {
                arrayM.append(_value);
            }
        }
        
        
        return arrayM;
        
    }
    
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath);
        let horizontalMargin = ((self.collectionView?.width ?? 0.0) - self.itemSize.width * CGFloat(self.rowCount)) / CGFloat(self.rowCount - 1);
        let page = indexPath.item / self.pageCount;
        let line = (indexPath.item % self.pageCount) / self.rowCount;
        let x = (self.itemSize.width + horizontalMargin) * CGFloat(indexPath.item % self.rowCount) + (self.collectionView?.width ?? 0.0) *  CGFloat(page);
        let y = CGFloat(line) * (self.itemSize.height + self.verticalMargin);
        attributes.frame = CGRect.init(x: x, y: y, width: self.itemSize.width, height: self.itemSize.height);
        
        return attributes;
    }
    
    
    
    public override var collectionViewContentSize: CGSize {
        if self.collectionView?.numberOfItems(inSection: 0) == 0 {
            return self.collectionView?.size ?? CGSize.zero;
        }
       
        self.calculateAppropriateRowCount(rowCount: self.rowCount)
        
        
        //一共多少页
        var page =  Float(self.collectionView?.numberOfItems(inSection: 0) ?? 0) / Float(self.pageCount);
        
        if page > Float((self.collectionView?.numberOfItems(inSection: 0) ?? 0) / self.pageCount) {
            page += 1;
        }
        //多少行
        var rowNum = pageCount / self.rowCount;
        let lineF = CGFloat(self.pageCount) / CGFloat(self.rowCount);
        if lineF > CGFloat(rowNum) {
            rowNum += 1;
        }
        let height = CGFloat(rowNum) * self.itemSize.height + CGFloat((rowNum - 1)) * self.verticalMargin;
        
        return CGSize.init(width: (self.collectionView?.width ?? 0.0) * CGFloat(Int(page)) , height: height);
        
    }
    
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        return false;
    }
    
    
    /**
    适配宽度  计算每行的数量
     */
    private func calculateAppropriateRowCount(rowCount: Int) {
        if self.collectionView?.width == 0 || self.collectionView == nil {
            return
        }
        let essentialWidth = CGFloat(rowCount) * self.itemSize.width;
        if essentialWidth > self.collectionView?.width ?? 0 {
            self.calculateAppropriateRowCount(rowCount: rowCount - 1);
        } else {
            
            self.rowCount = rowCount;
        }
    }
    
}
