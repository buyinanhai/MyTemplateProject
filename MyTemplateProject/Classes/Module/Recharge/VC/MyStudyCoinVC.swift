//
//  MyStudyCoinVC.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/9/11.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit
import DYTemplate

class MyStudyCoinVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "我的学币";
        self.setupSubview();
        self.tableView.begainRefreshData();
        DYPurchaseManager.addPaymentObserwer()
        NotificationCenter.default.addObserver(self, selector: #selector(chargeSuccessed(_ :)), name: .init(dy_Notification_purchase_chargeSuccessed), object: nil)
        // Do any additional setup after loading the view.
    }
    @objc
    private func chargeSuccessed(_ info: Notification) {
        
        if let result = info.object as? [String : Any] {
            
            let price = 1;
            self.myCoinLabel.text = String.init(format: "我的学币：%02d", price);
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        self.navigationController?.isNavigationBarHidden = true;
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        self.navigationController?.isNavigationBarHidden = false;
    }
    
    
    private func setupSubview() {
        self.view.backgroundColor = UIColor.init(hexString: "#F7F7F7");
        
        
        let imageView = UIImageView.init();
        imageView.image = UIImage.init(named: "recharge-my-coin-bg");
        
        self.view.addSubview(imageView);
        imageView.mas_makeConstraints { (make) in
            make?.left.top()?.right()?.offset();
            make?.height.equalTo()(self.view)?.multipliedBy()(0.7);
        }
        
        self.view.addSubview(self.titleLabel)
        self.titleLabel.mas_makeConstraints { (make) in
            make?.centerX.offset();
            if #available(iOS 11.0, *) {
                make?.top.equalTo()(self.view.mas_safeAreaLayoutGuideTop)?.offset()(15);
            } else {
                make?.top.offset()(57);

                // Fallback on earlier versions
            };
        }
        self.view.addSubview(self.backBtn);
        self.backBtn.mas_makeConstraints { (make) in
            make?.left.offset()(15);
            make?.centerY.equalTo()(self.titleLabel);
            make?.size.offset()(35);
        }
        self.backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside);
        
        let headerView = UIView.init();
        headerView.backgroundColor = UIColor.white;
        headerView.addRound(15);
        
        self.view.addSubview(headerView);
        headerView.mas_makeConstraints { (make) in
            make?.left.offset()(15);
            make?.right.offset()(-15);
            make?.height.offset()(72);
            make?.top.equalTo()(self.titleLabel.mas_bottom)?.offset()(50);
        }
        
        let coinImageV = UIImageView.init(image: UIImage.init(named: "recharge-mycoin"));
        
        
    
        headerView.addSubview(coinImageV);
        headerView.addSubview(self.myCoinLabel);
        headerView.addSubview(self.chargeBtn);
        
        coinImageV.mas_makeConstraints { (make) in
            make?.centerY.offset();
            make?.left.offset()(15);
            make?.size.offset()(20);
            
        }
        self.myCoinLabel.mas_makeConstraints { (make) in
            make?.centerY.offset();
            make?.left.equalTo()(coinImageV.mas_right)?.offset()(10);
            make?.right.equalTo()(self.chargeBtn.mas_left)?.offset()(-5);
            
        }
        
        self.chargeBtn.mas_makeConstraints { (make) in
            make?.right.offset()(-15);
            make?.centerY.offset();
            make?.width.offset()(72);
            make?.height.offset()(30);
        }
        
        self.view.addSubview(self.tableView);
        self.tableView.mas_makeConstraints { (make) in
            make?.top.equalTo()(headerView.mas_bottom)?.offset()(15);
            make?.left.offset()(15);
            make?.right.offset()(-15);
            make?.bottom.offset()(-20);
        }
        
        self.chargeBtn.addTarget(self, action: #selector(chargeBtnClick), for: .touchUpInside);
    }
    
    @objc
    private func chargeBtnClick() {
        
        let vc = ChargeVC.init();
        self.navigationController?.pushViewController(vc, animated: true);
        
    }
    
    private func loadData(page: Int,result: @escaping DYTableView_Result) {
        
        ChargeNetwork.getCoinRecordList().dy_startRequest { (response, error) in
            
            if let _result = response as? [String : Any] {
                
                if let datas = _result["iosCoinRecordList"] as? [[String : Any]] {
                    var models:[MyStudyCoinCellModel] = [];
                    for item in datas {
                        if let model = MyStudyCoinCellModel.init(JSON: item) {
                            
                            models.append(model);
                        }
                    }
                    result(models);
                }
                
                if let amountCoins = _result["iosCoinNum"] {
                    self.myCoinLabel.text = "我的学币：\(amountCoins)";
                }
            } else {
                
                DYNetworkHUD.showInfo(message: error?.errorMessage ?? "网络异常，请稍后重试！");
                result([]);
            }
            
        }
        
    }

    
    @objc
    private func backBtnClick() {
        
        self.navigationController?.popViewController(animated: true);
        
    }
    
    private lazy var titleLabel: UILabel = {
        
        let view = UILabel.init();
        view.font = UIFont.boldSystemFont(ofSize: 17)
        view.textColor = UIColor.white;
        view.text = "我的学币";
        return view;
    }()
    private lazy var backBtn: UIButton = {
        
        let view = UIButton.init();
        view.setImage(UIImage.init(named: "player-back-button"), for: .normal);
        
        return view;
    }()
    private lazy var myCoinLabel: UILabel = {
        
        let view = UILabel.init();
        view.text = "我的学币：";
        view.font = UIFont.systemFont(ofSize: 17)
        view.textColor = UIColor.init(hexString: "#FB9138");
        
        return view;
    }()
    private lazy var chargeBtn: UIButton = {
        
        let view = UIButton.init();
        view.setImage(UIImage.init(named: "recharge-mycoin-bag"), for: .normal);
        view.setTitle("充值", for: .normal);
        view.addRound(15);
        view.titleLabel?.font = UIFont.systemFont(ofSize: 15);
        view.setTitleColor(UIColor.init(hexString: "#FCAB54"), for: .normal);
        view.backgroundColor = UIColor.init(hexString: "#FFF1D7");
        
        return view;
    }()
    
    private lazy var tableView: DYTableView = {
        
        let view = DYTableView.init();
        
        view.register(MyStudyCoinCell.self, forCellReuseIdentifier: "cell");
        view.rowHeight = 75;
        view.loadDataCallback = {
           [weak self] (page, result) in
            
            self?.loadData(page: Int(page), result: result);
        }
        view.addRound(15);
        view.dy_separateInsets = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
        view.allowsSelection = false;
        return view;
    }()
    
    private var previousNavBarBackground: UIColor?
    
    
    deinit {
        NotificationCenter.default.removeObserver(self);
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
