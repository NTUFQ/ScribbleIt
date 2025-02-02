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

protocol RestoreStateDelegate {
    func restoreState(current: UIImage?, stack: [UIImage?])
}

class MenuViewController: UIViewController, StoreStateDelegate{
    


    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var collaborationModeButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var daillyChallengeButton: UIButton!
    @IBOutlet weak var lockView: UIView!

    @IBOutlet weak var pofileImage: SwiftyAvatar!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var continueDrawingButton: UIButton!
    var user: UserInfo?
    var storedImage: UIImage?
    var storedStack: [UIImage?] = []
    var storedUndoStack: [UIImage?] = []
    var storedTemplate: Template?
    
    var id:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.continueDrawingButton.isEnabled = false
        self.navigationController?.navigationBar.isHidden = true
        
        if FBSDKAccessToken.current() != nil{
            lockView.isHidden = true
            self.id = FBSDKAccessToken.current().userID
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
                    API().postUser(pk: json["id"].stringValue, name: json["name"].stringValue){
                        isNewUser in
                        if isNewUser{
                            self.toTutorial()
                            print("New user created successfully!")
                        }
                    }
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
        else{
            daillyChallengeButton.isEnabled = false
            collaborationModeButton.isEnabled = false
            galleryButton.isEnabled = false
        }
    }
    
    func toTutorial() {
        //add tutorial function
        return
    }
    
    @IBAction func backToMenu(_ segue: UIStoryboardSegue){}
    
    @IBAction func logout(_ sender: AnyObject) {
        if FBSDKAccessToken.current() != nil {
            FBSDKLoginManager().logOut()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier{
            switch id{
            case "MenuToDrawing":
                let drawingViewController: DrawingViewController = segue.destination as! DrawingViewController
                drawingViewController.delegate = self
                break
            case "MenuToContinueDrawing":
                let continueDrawingViewController: DrawingViewController = segue.destination as! DrawingViewController
                continueDrawingViewController.current = self.storedImage
                continueDrawingViewController.imageList = self.storedStack
                continueDrawingViewController.template = self.storedTemplate
            case "MenuToLobby":
                let lobbyViewController = segue.destination as! LobbyViewController
                if self.id != nil {
                    lobbyViewController.id = self.id!
                    print(self.nameLabel.text!)
                    lobbyViewController.name = self.nameLabel.text!
//                    lobbyViewController.userName1.text = self.nameLabel.text
                    lobbyViewController.image = self.pofileImage.image!
                }
            default:
                break
            }
        }

    }
    
    func storeState(current: UIImage?, stack: [UIImage?], undoStack: [UIImage?], template: Template?) {
        self.storedImage = current
        self.storedStack = stack
        self.storedUndoStack = undoStack
        self.storedTemplate = template
        self.continueDrawingButton.isEnabled = true
    }
    
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
