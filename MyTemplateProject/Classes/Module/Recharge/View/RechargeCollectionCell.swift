//
//  RechargeCollectionCell.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/9/12.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit

class RechargeCollectionCellModel {
    
    var coinCount: Int?
    var priceCount: Int?
    
    var isSelected: Bool = false;
    
    
}

class RechargeCollectionCell: UICollectionViewCell {

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    public var model:AnyObject? {
        
        didSet {
            
            if let _model = self.model as? RechargeCollectionCellModel {
                
                
                self.titleLabel.text = String.init(format: "%d 学币", _model.coinCount ?? 0)
                self.subtitleLabel.text = String.init(format: "￥%d", _model.priceCount ?? 0)
                if _model.isSelected  {
                    
                    self.bgImageView.image = UIImage.init(named: "recharge-coin-selected");
                    self.titleLabel.textColor = UIColor.white;
                    self.subtitleLabel.backgroundColor = UIColor.init(hexString: "#FFA018");
                    self.subtitleLabel.textColor = UIColor.white;
                } else {
                    self.bgImageView.image = UIImage.init(named: "recharge-coin-normal");
                    self.titleLabel.textColor = UIColor.init(hexString: "#555555");
                    self.subtitleLabel.backgroundColor = UIColor.init(hexString: "#E5E5E5");
                    self.subtitleLabel.textColor = UIColor.init(hexString: "#555555");
                }

            }
            
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subtitleLabel.addRound(5.5);
        self.subtitleLabel.adjustsFontSizeToFitWidth  = true;
    }

}
