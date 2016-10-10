//
//  MenuViewController.swift
//  ScribbleIt
//
//  Created by Fu Qiang on 10/11/16.
//  Copyright © 2016 Fu Qiang. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftyJSON
import Alamofire
class MenuViewController: UIViewController{
    



    @IBOutlet weak var pofileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        if FBSDKAccessToken.current() != nil{
            print(FBSDKAccessToken.current())
            // request for basic info
            let parameters = [
                "fields": "id, name, first_name, last_name, age_range, link, gender, locale, timezone, picture, updated_time, verified"
            ]
            let graphRequest = FBSDKGraphRequest(graphPath: "/me", parameters: parameters)
            graphRequest?.start(){
                (_: FBSDKGraphRequestConnection?, result: Any?, error: Error?) in
                if let error = error{
                    print(error)
                }
                else{
                    print(result)
                    let json = JSON(result!)
                    self.nameLabel.text = json["name"].stringValue
                }
            }
            // request for user pic
            let pictureParameters = [
                "width": 200,
                "height": 200,
                "redirect": "false"
            ] as [String : Any]
            let pictureGraphRequest = FBSDKGraphRequest(graphPath: "/me/picture", parameters: pictureParameters)
            pictureGraphRequest?.start(){
                (_: FBSDKGraphRequestConnection?, result: Any?, error: Error?) in
                print("request for picture")
                if let error = error{
                    print(error)
                }
                else{
                    print(result)
                    let json = JSON(result!)
                    let url = json["data", "url"].stringValue
                    self.pofileImage.imageFromUrl(urlString: url)
                }
            }
        }
    }
    
    @IBAction func backToMenu(_ segue: UIStoryboardSegue){}
    
    
    
}

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(url: url as URL)
            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) {
                (response: URLResponse?, data: Data?, error: Error?) -> Void in
                self.image = UIImage(data: data! as Data)
            }
        }
    }
}
