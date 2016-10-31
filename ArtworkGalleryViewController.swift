//
//  ArtworkGalleryViewController.swift
//  ScribbleIt
//
//  Created by Fu Qiang on 10/14/16.
//  Copyright © 2016 Fu Qiang. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import SwiftyJSON
import FaveButton
import Popover
import PopupDialog
class ArtworkGalleryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var artworkTableView: UITableView!
    
    
    var artworks: [Artwork]? = nil
    var api = API()
    let cellIdentifier = "Cell"
    var textInput: UITextField? = nil
    
    @IBAction func popoverShow(_ sender: AnyObject) {
        let startPoint = CGPoint(x: self.view.frame.width - 60, y: 55)
        let aView = UIView(frame: CGRect(x: 50, y: 0, width: self.view.frame.width - 100, height: 400))
        if let artwork = artworks?[sender.tag]{
            var text = ""
            for comment in artwork.comment!{
                text += comment.owner_name! + ": " + comment.text + "\n"
            }
            var textView = UITextView(frame: CGRect(x: 10, y: 50, width: aView.frame.width - 100, height: 300))
            textView.text = text
            textView.font = UIFont(name: (textView.font?.fontName)!, size: 25)
            aView.addSubview(textView)
        }
        textInput = UITextField(frame: CGRect(x: 0, y: 300, width: aView.frame.width - 200, height: 50))
        if textInput != nil {
            textInput!.backgroundColor = UIColor.lightGray
        }
        let postButton = UIButton(frame: CGRect(x: textInput!.frame.maxX, y: 300, width: 80, height: 50))
        postButton.backgroundColor = UIColor.red
        postButton.setTitle("Post", for: .normal)
        postButton.tag = sender.tag
        postButton.addTarget(self, action: #selector(postComment(_:)), for: .touchUpInside)
        aView.addSubview(textInput!)
        aView.addSubview(postButton)
        let popover = Popover()
        popover.show(aView, point: startPoint)
    }
    
    func postComment(_ sender: UIButton!) {
        print(sender.tag)
        if textInput != nil{
            if !(textInput!.text!).isEmpty{
                print(textInput!.text!)
                print(FBSDKAccessToken.current().userID)
                print(artworks![sender.tag].pk)
//                API().postComment(commentText: "test2222", ownerId: "2113430318882027", artworkId: 6){
//                    result in
//                    print(result)
//                }
                API().postComment(commentText: textInput!.text!, ownerId: FBSDKAccessToken.current().userID, artworkId: artworks![sender.tag].pk){
                    result in
                    if result{
                        print("good!!!")
                    }
                }
            }
        }
        print("posted!!!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if FBSDKAccessToken.current() != nil{
            print("user found!")
            loadArtworks(ownerId: FBSDKAccessToken.current().userID)
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @IBAction func loadDiscover(_ sender: AnyObject) {
        api.getDiscover{
            (artwork_list: [Artwork]?) in
//            var a_list = [Artwork]()
//            if FBSDKAccessToken.current() != nil{
//                for artwork in artwork_list!{
//                    if artwork.owner_id != FBSDKAccessToken.current().userID{
//                        a_list.append(artwork)
//                    }
//                }
//                self.artworks = a_list
//                self.artworkTableView.reloadData()
//            }
//            else{
//                self.artworks = artwork_list
//                self.artworkTableView.reloadData()
//            }
            self.artworks = artwork_list
            self.artworkTableView.reloadData()
        }
    }
    
    func loadArtworks(ownerId: String){
        api.getUser(pk: ownerId){
            (user: UserInfo?) in
            if user != nil {
                self.artworks = user!.artwork
                self.artworkTableView.reloadData()
            }

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if artworks == nil{
            return 0
        }
        return artworks!.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ArtworkGalleryTableViewCell
        cell.selectionStyle = .none
        cell.commentButton.tag = indexPath.row
        if let artwork = artworks?[indexPath.row]{
        cell.owner.text = artwork.owner_name!
        cell.like.text = "\(artwork.like!.count)"
        cell.time.text = artwork.time
        if let url = artwork.url{
            cell.Picture.imageFromUrl(urlString: url)
            }
            
            let pictureParameters = [
                "width": 50,
                "height": 50,
                "redirect": "false"
                ] as [String : Any]
            let pictureGraphRequest = FBSDKGraphRequest(graphPath: "/"+artwork.owner_id!+"/picture", parameters: pictureParameters)
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
                cell.profileImage.imageFromUrl(urlString: url)
                }
            }
        }

        return cell
    }

    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
