//
//  ChargeCollectionCell.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/9/12.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit

class ChargeCollectionCellModel {
    
    var coinCount: Int?
    var priceCount: Int?
    
    var isSelected: Bool = false;

    var id: Int?
    
}

class ChargeCollectionCell: UICollectionViewCell {

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var coinView: DYButton!
    
    public var model:AnyObject? {
        
        didSet {
            
            if let _model = self.model as? ChargeCollectionCellModel {
                
                self.coinView.setTitle(String.init(format: "%d 学币", _model.coinCount ?? 0), for: .normal);
                self.subtitleLabel.text = String.init(format: "￥%d", _model.priceCount ?? 0)
                self.coinView.isSelected = _model.isSelected;
                
                if _model.isSelected  {
                    
                    self.bgImageView.image = UIImage.init(named: "recharge-coin-selected");
                    self.subtitleLabel.textColor = UIColor.white;
                } else {
                    self.bgImageView.image = UIImage.init(named: "recharge-coin-normal");
                    self.subtitleLabel.textColor = UIColor.init(hexString: "#555555");
                    
                }

            }
            
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subtitleLabel.addRound(5.5);
        self.subtitleLabel.adjustsFontSizeToFitWidth  = true;
        self.coinView.dy_setBackgroundColor(UIColor.dy_hex("#FF9F18"), for: .selected);
        self.coinView.addRound(5.5);
        self.coinView.isUserInteractionEnabled = false;
    }

}
