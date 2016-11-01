//
//  LobbyViewController.swift
//  ScribbleIt
//
//  Created by Fu Qiang on 10/31/16.
//  Copyright © 2016 Fu Qiang. All rights reserved.
//

import UIKit
import Starscream
import SwiftyJSON
import FBSDKCoreKit
import NVActivityIndicatorView
class LobbyViewController: UIViewController {
    @IBOutlet weak var userImage1: SwiftyAvatar!
    @IBOutlet weak var userName1: UILabel!
    @IBOutlet weak var userImage2: SwiftyAvatar!
    @IBOutlet weak var userName2: UILabel!
    @IBOutlet weak var loadingView: UIView!

    
    var id:String = ""
    var name:String = ""
    var image = #imageLiteral(resourceName: "user_profile")
    var player2id:String = ""
    var player2name:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let loading = NVActivityIndicatorView(frame: frame, type: NVActivityIndicatorType.lineScalePulseOut, color: UIColor
            .white, padding: 0)
        loading.startAnimating()
        loadingView.addSubview(loading)
        self.userName1.text = name
        self.userImage1.image = image
        let myData = JSON(["type": "join", "user_id": id, "user_name": name]).rawString()
        print(myData!)
        
        let socket = WebSocket(url: URL(string: "ws://128.199.250.111:3002/lobby")!)
        socket.onConnect = {
            socket.write(string:"user connect successfully")
            socket.write(string: myData!)
        }
        socket.onDisconnect = {
            error in
            print(error)
            print("disconnected from lobby")
        }
        socket.onText = {
            text in
            print(text)
            let json = JSON.parse(text)
            print(json["type"].stringValue)
            print(json["user_id"].stringValue)
            if (json["type"].stringValue == "join") && (json["user_id"].stringValue != self.id){
                self.player2id = json["user_id"].stringValue
                self.player2name = json["user_name"].stringValue
                self.userName2.text = self.player2name
                socket.write(string: myData!)
                socket.disconnect()
                self.performSegue(withIdentifier: "LobbyToDrawing", sender: self)
            }
//            if json["type"] == "start" && (json["user_id"].stringValue != self.id) {
//                
//            }
        }
//        socket.onData = {
//            data in
//            let json = JSON(data: data)
//            print(json)
//            if json["type"].stringValue == "join" && (json["user_id"].stringValue != self.id) {
//                self.player2id = json["user_id"].stringValue
//                self.player2name = json["user_name"].stringValue
//                self.userName2.text = self.player2name
//                socket.write(string: myData!)
//            }
//        }
        socket.connect()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier{
            switch id{
            case "LobbyToDrawing":
                let drawingViewController = segue.destination as! DrawingViewController
                drawingViewController.collaborationMode = true
                drawingViewController.id = self.id
                drawingViewController.name = self.name
                drawingViewController.player2id = self.player2id
                drawingViewController.player2name = self.player2name
                if Int(self.id)! > Int(self.player2id)!  {
                    drawingViewController.turn = 1
                }
                break
            default:
                break
            }
        }
        
    }
    
}
