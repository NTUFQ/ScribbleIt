//
//  TestViewController.swift
//  ScribbleIt
//
//  Created by Fu Qiang on 10/14/16.
//  Copyright © 2016 Fu Qiang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request("http://127.0.0.1:8000/api/user/001").responseJSON{ response in
            if let data = response.data{
                let json = JSON(data: data)
                print(json)
                print("------------------------")
                print(json["comments"])
                print("------------------------")
                print(json["likes"])
                print("------------------------")
                print(json["fbid"])
                print("------------------------")
                print(json["artwork_list"])
                let aj = json["artwork_list"]
                for (_, atw) in aj{
                    print(atw)
                }
                print("------------------------")
            }
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
