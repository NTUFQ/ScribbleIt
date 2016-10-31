//
//  API.swift
//  ScribbleIt
//
//  Created by Fu Qiang on 10/9/16.
//  Copyright © 2016 Fu Qiang. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class Like{
    let pk: Int
    var artwork: String?
    var owner_id: String?
    var owner_name: String?
    var time: String?
    
    init(pk: Int, artwork: String?, owner_id: String?, owner_name: String?, time: String?) {
        self.pk = pk
        self.artwork = artwork
        self.owner_id = owner_id
        self.owner_name = owner_name
        self.time = time
    }
    
    init(json: JSON) {
        self.pk = json["id"].intValue
        self.artwork = json["artwork"].string
        self.owner_id = json["owner", "fbid"].stringValue
        self.owner_name = json["owner", "name"].stringValue
        self.time = json["created_by"].stringValue
    }
}

class Comment{
    let pk: Int
    var text: String
    var artwork: String?
    var owner_id: String
    var owner_name: String?
    var time: String?
    
    init(pk: Int, text: String, artwork: String?, owner_id: String, owner_name: String?, time: String?) {
        self.pk = pk
        self.text = text
        self.artwork = artwork
        self.owner_id = owner_id
        self.owner_name = owner_name
        self.time = time
    }
    
    init(json: JSON) {
        self.pk = json["id"].intValue
        self.text = json["text"].stringValue
        self.artwork = json["artwork"].string
        self.owner_id = json["owner", "fbid"].stringValue
        self.owner_name = json["owner", "name"].stringValue
        self.time = json["created_by"].stringValue
    }
}

class Artwork{
    let pk: Int
    var name: String?
    var url: String?
    var owner_id: String?
    var owner_name: String?
    var comment: [Comment]?
    var like: [Like]?
    var template_id: Int?
    var template_name: String?
    var time: String
    
    init(pk: Int, name: String?, url: String?, owner_id: String?, owner_name: String?, comment: [Comment]?, like: [Like]?, template_id: Int?, template_name: String?, time: String) {
        self.pk = pk
        self.name = name
        self.url = url
        self.owner_id = owner_id
        self.owner_name = owner_name
        self.comment = comment
        self.like = like
        self.template_id = template_id
        self.template_name = template_name
        self.time = time
    }
    
    init(json: JSON) {
        self.pk = json["id"].intValue
        self.owner_id = json["owner", "fbid"].stringValue
        self.owner_name = json["owner", "name"].stringValue
        self.url = json["picture"].string
        self.comment = [Comment]()
        for (_, commentJson) in json["comments"]{
            self.comment?.append(Comment(json: commentJson))
        }
        self.like = [Like]()
        for (_, likeJson) in json["likes"]{
            self.like?.append(Like(json: likeJson))
        }
        self.template_id = json["template", "id"].int
        self.template_name = json["template", "name"].string
        self.time = json["created_by"].stringValue
    }
}

class UserInfo{
    let pk: String
    var name: String?
    var email: String?
    var picture: UIImage?
    var artwork: [Artwork]?
    
    init(pk: String, name: String?, email: String?, picture: UIImage?, artwork: [Artwork]?) {
        self.pk = pk
        self.name = name
        self.email = email
        self.picture = picture
        self.artwork = artwork
    }
    
    init(json: JSON) {
        self.pk = json["fbid"].stringValue
        self.name = json["name"].string
        self.email = json["email"].string
        self.artwork = [Artwork]()
        for (_, artworkJson) in json["artwork_list"]{
            self.artwork?.append(Artwork(json: artworkJson))
        }
    }
}

class API{
    init() {
        //Alamofire.request("http://127.0.0.1:8000/api/artwork/5").validate().responseJSON{_ in }
    }
    let URL = "http://128.199.250.111:3002"
    
    // I dont know how to handle asynchronic request as normal function... just use callback
    // Example:
    //      to get an userInfo object of facebook id "789789"
    //      getUserInfo(pk: "789789"){
    //          user -> { //What you want to do with user object }
    //      }
    
    func getArtwork(pk: Int, completeHandler: @escaping (_ artwork: Artwork?) -> ()){
        Alamofire.request(URL + "/api/artwork/" + String(pk)).validate().responseJSON{
            response in
            switch response.result {
            case .success:
                let json = JSON(data: response.data!)
                print(json)
                let artwork = Artwork(json: json)
                completeHandler(artwork)
            case .failure(let error):
                print(error)
                completeHandler(nil)
            }
        }
    }
    
    func getDiscover(completeHandler: @escaping (_ artworks: [Artwork]?) -> ()){
        Alamofire.request(URL + "/api/discover/").validate().responseJSON{
            response in
            switch response.result {
            case .success:
                var artworks = [Artwork]()
                let json = JSON(data: response.data!)
                print(json["results"])
                for (_, artworkJson) in json["results"]{
                    artworks.append(Artwork(json: artworkJson))
                }
                completeHandler(artworks)
                break
            case .failure:
                print("failed to get discovery data")
            }
        }
    }
    
    func getUser(pk: String, completeHandler: @escaping (_ user: UserInfo?) -> ()){
        Alamofire.request(URL + "/api/user/" + pk).validate().responseJSON{
            response in
            switch response.result {
            case .success:
                let json = JSON(data: response.data!)
                let userInfo = UserInfo(json: json)
                completeHandler(userInfo)
            case .failure(let error):
                print(error)
                completeHandler(nil)
            }
        }
    }
    
    // this function is for creating new user
    // callback function can be used to toogle tutorial
    // tested in 2016-10-14 23:49:32
    func postUser(pk: String, name: String, completeHandler: @escaping (_ isNewUser: Bool)->()){
        let parameter = [
            "fbid": pk,
            "name": name,
            ]
        Alamofire.request(URL+"/api/newuser/", method: .post, parameters: parameter).validate().responseJSON{
            response in
            print(JSON(response.data))
            print(response.result)
            switch response.result {
            case .success:
                // if the user is new user
                completeHandler(true)
            case .failure:
                // if the user is old user
                completeHandler(false)
            }
        }
    }
    
    func postComment(commentText: String, ownerId: String, artworkId: Int, completeHandler: @escaping (_ result: Bool)->()) {
        let parameter = [
            "text": commentText,
            "owner": ownerId,
            "artwork": artworkId
        ] as [String : Any]
        
        Alamofire.request(URL+"/api/comment/", method: .post, parameters: parameter).validate().responseJSON{
            response in
            switch response.result {
            case .success:
                completeHandler(true)
            case .failure(let error):
                print(error)
                completeHandler(false)
            }
        }
    }
    
    func postLike(ownerId: String, artworkId: Int, completeHandler: @escaping (_ result: Bool)->()) {
        let parameter = [
            "owner": ownerId,
            "artwork": artworkId
            ] as [String : Any]
        
        Alamofire.request(URL+"/api/like/", method: .post, parameters: parameter).validate().responseJSON{
            response in
            switch response.result {
            case .success:
                completeHandler(true)
            case .failure:
                completeHandler(false)
            }
        }
    }
    
    
    func postArtwork(name: String?, picture: UIImage?, owner: String?, template: Int?, completeHandler: @escaping (_ result: Bool) -> ()) {
        var parameter = [
            "owner": owner!
        ]
        if (template != nil) {
            parameter.updateValue(String(template!), forKey: "template")
        }
        
        Alamofire.upload(multipartFormData: {
            MultipartFormData in
            
            if let _image = picture {
                if let imageData = UIImageJPEGRepresentation(_image, 0.5) {
                    MultipartFormData.append(imageData, withName: "picture", fileName: "pic.jpg", mimeType: "image/jpg")
                }
            }
            for (key, value) in parameter {
                MultipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            }, usingThreshold: UInt64.init(), to: URL + "/api/artwork/", method: .post, headers: nil, encodingCompletion: {
                encodingResult in
                
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        switch response.result {
                        case .success(_):
                            completeHandler(true)
                        case .failure(_):
                            completeHandler(false)
                        }
                        
                    }
                case .failure(_):
                    completeHandler(false)
                }
        })
    }
}
