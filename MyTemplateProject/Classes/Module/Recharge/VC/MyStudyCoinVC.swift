//
//  MyStudyCoinVC.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/9/11.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit

class MyStudyCoinVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    
    private func setupSubview() {
        
        let imageView = UIImageView.init();
        imageView.image = UIImage.init(named: "recharge-my-coin-bg");
        
        self.view.addSubview(imageView);
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
