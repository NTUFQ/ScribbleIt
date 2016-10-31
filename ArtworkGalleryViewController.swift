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
    var textView:UITextView? = nil
    var name = ""
    
    @IBAction func popoverShow(_ sender: AnyObject) {
        let startPoint = CGPoint(x: self.view.frame.width - 60, y: 55)
        let aView = UIView(frame: CGRect(x: 50, y: 0, width: self.view.frame.width - 100, height: 400))
        if let artwork = artworks?[sender.tag]{
            var text = ""
            for comment in artwork.comment!{
                text += comment.owner_name! + ": " + comment.text + "\n"
            }
            textView = UITextView(frame: CGRect(x: 10, y: 50, width: aView.frame.width - 100, height: 300))
            textView?.text = text
            textView?.font = UIFont(name: "HelveticaNeue", size: 18)
            aView.addSubview(textView!)
        }
        textInput = UITextField(frame: CGRect(x: 0, y: 300, width: aView.frame.width - 230, height: 50))
        if textInput != nil {
            textInput!.backgroundColor = UIColor.lightGray
        }
        let postButton = UIButton(frame: CGRect(x: textInput!.frame.maxX + 20, y: 300, width: 80, height: 50))
        //postButton.backgroundColor = UIColor.red
        postButton.setTitle("POST", for: .normal)
        postButton.setTitleColor(UIColor.red, for: .normal)
        postButton.titleLabel!.font = UIFont(name: "KBZipaDeeDooDah", size: 30)
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
                textView?.text! += self.name + ": " + textInput!.text! + "\n"
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
    
    @IBAction func deleteArtwork(_ sender: AnyObject) {
        let popup = PopupDialog(title: "Do you want to delete this artwork?", message: nil)
        let button1 = DefaultButton(title: "Delete") {
            self.api.deleteArtwork(pk: (self.artworks?[sender.tag].pk)!){
                result in
                if result == true{
                    self.artworks?.remove(at: sender.tag)
                    self.artworkTableView.reloadData()
                    self.present(PopupDialog(title: "Delete successfully!", message: nil), animated: true, completion: nil)
                }
            }
        }
        let button2 = CancelButton(title: "Cancel"){
        }
        popup.addButtons([button1, button2])
        self.present(popup, animated: true, completion: nil)
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
    
    @IBAction func loadMyGallery(_ sender: AnyObject) {
        loadArtworks(ownerId: FBSDKAccessToken.current().userID)
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
            self.artworks = artwork_list?.reversed()
            self.artworkTableView.reloadData()
        }
    }
    
    func loadArtworks(ownerId: String){
        api.getUser(pk: ownerId){
            (user: UserInfo?) in
            if user != nil {
                self.artworks = user!.artwork?.reversed()
                self.name = (user!.artwork?.last?.owner_name)!
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
            cell.artwork = artwork
        cell.owner.text = artwork.owner_name!
        cell.like.text = "\(artwork.like!.count)"
            cell.likeButton?.isSelected = false
            for likeInfo in artwork.like!{
                if likeInfo.owner_id == FBSDKAccessToken.current().userID{
                    cell.likeButton?.isSelected = true
                    cell.likePk = likeInfo.pk
                }
            }
            cell.time.text = timeAgoSinceDate(date: artwork.time.toDateTime(), numericDates: true)
            if  artwork.owner_id == FBSDKAccessToken.current().userID{
                cell.deleteButton.tag = indexPath.row
                cell.deleteButton.isHidden = false
            }
            else{
                print("uuuuuuu")
                print(artwork.owner_name)
                cell.deleteButton.isHidden = true
            }
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
    
    func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }

}

extension String
{
    func toDateTime() -> NSDate
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        
        //Parse into NSDate
        let dateFromString : NSDate = dateFormatter.date(from: self)! as NSDate
        
        //Return Parsed Date
        return dateFromString
    }
}
