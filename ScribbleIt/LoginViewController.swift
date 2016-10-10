//
//  LoginViewController.swift
//  ScribbleIt
//
//  Created by Fu Qiang on 10/10/16.
//  Copyright © 2016 Fu Qiang. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
//import Simplicity

class LoginViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        if FBSDKAccessToken.current() != nil{
            print("already logged in")
            self.toMenu()
        }
    }
    @IBAction func clickPlayAsGuest(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "LoginToMenu", sender: self)
    }
    
    @IBAction func clickLogOut(_ segue: UIStoryboardSegue){}
    
    @IBAction func testLogin(_ sender: AnyObject) {
        let loginManager = FBSDKLoginManager()
        let permissions = ["public_profile", "email"]
        let handler =  {
            (result: FBSDKLoginManagerLoginResult?, error: Error?) in
            if let error = error {
                print("error = \(error.localizedDescription)")
            } else if result!.isCancelled {
                print("user tapped on Cancel button")
            } else {
                print("authenticate successfully")
                self.toMenu()
            }
        }
        loginManager.logIn(withReadPermissions: permissions, from: self, handler: handler)
    }
    
    func toMenu() {
        self.performSegue(withIdentifier: "LoginToMenu", sender: self)
    }
//        Simplicity.login(Facebook()){
//            (accessToken, error) in
//            if error != nil {
//                print(error)
//                return
//            }
//            if accessToken != nil {
//                print(accessToken)
//                
//                return
//            }
//        }

}
    

