//
//  LoginVC.swift
//  MyTemplateProject
//
//  Created by 汪宁 on 2020/8/18.
//  Copyright © 2020 汪宁. All rights reserved.
//

import UIKit
import DYTemplate.DYNetwork
class LoginVC: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var pwdField: UITextField!
    
    
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }


    @IBAction func loginBtnClick(_ sender: Any) {
        

        if self.usernameField.text?.isEmpty ?? false || self.pwdField.text?.isEmpty ?? false {
            
            DYNetworkHUD.showInfo(message: "账户或密码不能为kong", inView: self.view);
            return;
        }
        
        CommonNetwork.createUser(userName: self.usernameField.text ?? "", password: self.pwdField.text ?? "").dy_startRequest { (response, error) in
            
            DYNetworkHUD.dismiss();
            
            print(response,error);
//            if let _response = response as? [String : Any]
            
            
        }
        
        
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
