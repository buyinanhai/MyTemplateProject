//
//  RechargeVC.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/9/11.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit
import DYTemplate

class RechargeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "学币充值";
        self.setupSubview();
        // Do any additional setup after loading the view.
        for (index,item) in [1,12,30,50].enumerated() {
            
            let model = RechargeCollectionCellModel.init();
            model.priceCount = item;
            model.coinCount = item;
            self.dataSource[index] = model;
        }
    }
    
    
    private func setupSubview() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "recharge-servicer-barbtn"), style: .plain, target: self, action: #selector(rightBarBtnClick));
        
        let scrollView = UIScrollView.init(frame: self.view.bounds);
        
        self.view.addSubview(scrollView);
        scrollView.mas_makeConstraints { (make) in
            make?.top.left()?.offset();
            make?.size.equalTo()(self.view);
        }
        scrollView.backgroundColor = .init(hexString: "#f5f5f5");
        
        scrollView.addSubview(upView);
        scrollView.addSubview(bottomView);
        self.upView.mas_makeConstraints { (make) in
            make?.left.offset()(15);
            make?.width.equalTo()(scrollView)?.offset()(-30)
            make?.top.offset()(20);
            make?.height.offset()(300);
        }
        self.bottomView.mas_makeConstraints { (make) in
            make?.left.offset()(15);
            make?.width.equalTo()(scrollView)?.offset()(-30)
            make?.top.equalTo()(self.upView.mas_bottom)?.offset()(20);
            make?.height.offset()(230);
        }
        
        self.upView.addSubview(self.coinLabel);
        self.upView.addSubview(self.collectionView);
        self.upView.addSubview(self.confirmBtn);
        
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.coinLabel.mas_makeConstraints { (make) in
            make?.left.offset()(15);
            make?.top.offset()(20);
        }
        self.collectionView.mas_makeConstraints { (make) in
            make?.left.offset()(15);
            make?.right.offset()(-15);
            make?.top.equalTo()(self.coinLabel.mas_bottom)?.offset()(20);
            make?.bottom.equalTo()(self.confirmBtn.mas_top)?.offset()(-20);
        }
        
        self.confirmBtn.mas_makeConstraints { (make) in
            make?.left.offset()(15);
            make?.right.offset()(-15);
            make?.bottom.offset()(-30);
            make?.height.offset()(40);
        }
        
        self.confirmBtn.addTarget(self, action: #selector(confirmBtnClick), for: .touchUpInside)
       
        let explainTitle = UILabel.init();
        explainTitle.font = UIFont.boldSystemFont(ofSize: 16)
        explainTitle.textColor = UIColor.hex("#333333");
        explainTitle.text = "充值说明";
        
        let explainContent = UILabel.init();
        explainContent.textColor = UIColor.init(hexString: "#797979");
        explainContent.text = "1.学币仅限ios系统消费，无法在其他系统中使用；\n2.学币用于购买优智多课堂APP中的班课商品，无法\n3.学币为虚拟币，充值后不会过期，但无法退款、提现或转赠他人\n4.在充值过程中遇到任何问题，可联系在线客服，或者拨打客服电话";
        explainContent.numberOfLines = 0;
        explainContent.font = UIFont.systemFont(ofSize: 13)
        
        let dialBtn = UIButton.init();
        dialBtn.setTitle("400-546-2456", for: .normal);
        dialBtn.setTitleColor(.init(hexString: "#FEB327"), for: .normal);
        dialBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        
        self.bottomView.addSubview(explainTitle);
        self.bottomView.addSubview(explainContent);
        self.bottomView.addSubview(dialBtn);
        
        explainTitle.mas_makeConstraints { (make) in
            make?.left.offset()(15);
            make?.top.offset()(20);
        }
        
        explainContent.mas_makeConstraints { (make) in
            make?.top.equalTo()(explainTitle.mas_bottom)?.offset()(15);
            make?.left.offset()(15);
            make?.right.offset()(-15);
            make?.bottom.equalTo()(dialBtn.mas_top)?.offset()(-5);
        }
        
        dialBtn.mas_makeConstraints { (make) in
            
            make?.left.offset()(15);
            make?.bottom.offset();
        }
        
        dialBtn.addTarget(self, action: #selector(dialBtnClick(_ :)), for: .touchUpInside)
    }
    
    //MARK: 联系客服
    private func showContactVC() {
        
    }
    
    //MARK: 开始充值
    private func begainRecharge() {
        
        
    }
  
    private lazy var upView: UIView = {
        
        let view = UIView.init();
        view.backgroundColor = UIColor.white;
        view.addRound(10);
        
        return view;
        
    }()
    private lazy var bottomView: UIView = {
        
        let view = UIView.init();
        view.backgroundColor = UIColor.white;
        view.addRound(10);
        
        return view;
        
    }()
    
    private lazy var coinLabel: UILabel = {
        
        let view = UILabel.init();
        view.font = UIFont.boldSystemFont(ofSize: 16)
        view.textColor = UIColor.hex("#333333");
        view.text = "学币：不到一个亿";
        return view;
    }()

    private lazy var collectionView: UICollectionView = {
        
        
        let layout = UICollectionViewFlowLayout.init();
        let view = UICollectionView.init(frame: .zero, collectionViewLayout: layout);
        view.backgroundColor = UIColor.white;
        view.register(UINib.init(nibName: "RechargeCollectionCell", bundle: nil), forCellWithReuseIdentifier: "cell");
        return view;
    }()
    
    private lazy var confirmBtn: UIButton = {
        
        let view = UIButton.init();
        view.setTitle("确定充值", for: .normal)
        view.backgroundColor = UIColor.hex("#FFE4B2");
        view.setTitleColor(.init(hexString: "#FD943A"), for: .normal);
        view.titleLabel?.font = UIFont.systemFont(ofSize: 15);
        view.addRound(20);
        
        return view;
    }()
    
    private var dataSource: [Int: RechargeCollectionCellModel] = [
        :
    ]
    
    private var currSelectedItem: Int?
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
//MARK: actions
extension RechargeVC {
    
    @objc
    private func confirmBtnClick() {
        
        if self.currSelectedItem != nil {
            
            let vc = UIAlertController.init(title: "充值提醒", message: "学币充值后不能退款、体现或转赠且仅可ios系统中购买班课类使用。建议联系客服了解详细充值规则", preferredStyle: .alert);
            let confirmAction = UIAlertAction.init(title: "确定充值", style: .default) { (confirm) in
                self.begainRecharge()
            }
            let contactAction = UIAlertAction.init(title: "联系客服", style: .cancel) { (cancle) in
                self.showContactVC();
            }
            vc.addAction(confirmAction);
            vc.addAction(contactAction);
            
            self.present(vc, animated: true, completion: nil);
        }
        
    }
    
    
    @objc
    private func dialBtnClick(_ sender: UIButton) {
        
        if let phoneNumber = sender.titleLabel?.text {
            
            UIApplication.shared.open(URL.init(string: "tel:\(phoneNumber)")!, options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly : false], completionHandler: nil)
        }
    }
    @objc
    private func rightBarBtnClick() {
        
        self.showContactVC();
    }
    
    
    
}

//MARK: delegate
extension RechargeVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                
        return self.dataSource.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RechargeCollectionCell;
        cell.model = self.dataSource[indexPath.item];
        return cell;
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        if self.currSelectedItem != nil {
            
            self.dataSource[self.currSelectedItem!]?.isSelected = false;
            collectionView.reloadItems(at: [IndexPath.init(item: self.currSelectedItem!, section: 0)])
        }
        let model = self.dataSource[indexPath.item];
        
        model?.isSelected = true;
        collectionView.reloadItems(at: [indexPath]);
        self.currSelectedItem = indexPath.item;
        self.confirmBtn.setTitle("￥\(model?.priceCount ?? 0) 确认充值", for: .normal);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return .init(width: 155, height: 64);
    }
    
    
}
