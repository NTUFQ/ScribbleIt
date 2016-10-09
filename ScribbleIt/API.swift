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
}

class Comment{
    let pk: Int
    var text: String?
    var artwork: String?
    var owner_id: String?
    var owner_name: String?
    var time: String?
    
    init(pk: Int, text: String?, artwork: String?, owner_id: String?, owner_name: String?, time: String?) {
        self.pk = pk
        self.text = text
        self.artwork = artwork
        self.owner_id = owner_id
        self.owner_name = owner_name
        self.time = time
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
    
    init(pk: Int, name: String?, url: String?, owner_id: String?, owner_name: String?, comment: [Comment]?, like: [Like]?, template_id: Int?, template_name: String?) {
        self.pk = pk
        self.name = name
        self.url = url
        self.owner_id = owner_id
        self.owner_name = owner_name
        self.comment = comment
        self.like = like
        self.template_id = template_id
        self.template_name = template_name
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
        self.email = email
        self.picture = picture
        self.artwork = artwork
    }
}

class API{
    init() {
        //Alamofire.request("http://127.0.0.1:8000/api/artwork/5").validate().responseJSON{_ in }
    }
    let URL = "http://127.0.0.1:8000"
    
    // I dont know how to handle asynchronic request as normal function... just use callback
    // Example:
    //      to get an userInfo object of facebook id "789789"
    //      getUserInfo(pk: "789789"){
    //          user -> { //What you want to do with user object }
    //      }
    
    func getArtwork(pk: Int, completeHandler: @escaping (_ artwork: Artwork?) -> ()){
        var artwork: Artwork?
        Alamofire.request(URL + "/api/artwork/" + String(pk)).validate().responseJSON{
            response in
            switch response.result {
            case .success:
                let json = JSON(data: response.data!)
                let name = json["name"].string
                let url = json["picture"].string
                let owner_id = json["owner", "fbid"].string
                let owner_name = json["owner", "name"].string
                var comment: [Comment]?
                var like: [Like]?
                let template_id = json["template","id"].int
                let template_name = json["template", "id"].string
                for (_, commentJson):(String, JSON) in json["comments"]{
                    let commentId = commentJson["id"].intValue
                    let commentText = commentJson["text"].string
                    let commentTime = commentJson["created_by"].string
                    let commentOwnerId = commentJson["owner", "fbid"].string
                    let commentOwnerName = commentJson["owner", "name"].string
                    let newComment = Comment(pk: commentId, text: commentText, artwork: nil, owner_id: commentOwnerId, owner_name: commentOwnerName, time: commentTime)
                    comment?.append(newComment)
                }
                for (_, likeJson):(String, JSON) in json["likes"]{
                    let likeId = likeJson["id"].intValue
                    let likeTime = likeJson["created_by"].string
                    let likeOwnerId = likeJson["owner", "fbid"].string
                    let likeOwnerName = likeJson["owner", "name"].string
                    let newLike = Like(pk: likeId, artwork: nil, owner_id: likeOwnerId, owner_name: likeOwnerName, time: likeTime)
                    like?.append(newLike)
                }
                artwork = Artwork(pk: pk, name: name, url: url, owner_id: owner_id, owner_name: owner_name, comment: comment, like: like, template_id: template_id, template_name: template_name)
                
                print(json)
                print(artwork!)
                print(artwork == nil)
                completeHandler(artwork)
            case .failure(let error):
                print(error)
                completeHandler(nil)
            }
        }
    }
    
    func getUser(pk: String, completeHandler: @escaping (_ user: UserInfo?) -> ()){
        var userInfo: UserInfo?
        Alamofire.request(URL + "/api/user/" + pk).validate().responseJSON{
            response in
            switch response.result {
            case .success:
                let json = JSON(data: response.data!)
                let name = json["name"].string
                let email = json["email"].string
                var artwork: [Artwork]?
                for (_, artworkJson):(String, JSON) in json["artwork_list"]{
                    let artworkId = artworkJson["id"].intValue
                    let name = artworkJson["name"].string
                    let url = artworkJson["picture"].string
                    let owner_id = artworkJson["owner", "fbid"].string
                    let owner_name = artworkJson["owner", "name"].string
                    var comment: [Comment]?
                    var like: [Like]?
                    let template_id = artworkJson["template","id"].int
                    let template_name = artworkJson["template", "id"].string
                    for (_, commentJson):(String, JSON) in json["comments"]{
                        let commentId = commentJson["id"].intValue
                        let commentText = commentJson["text"].string
                        let commentTime = commentJson["created_by"].string
                        let commentOwnerId = commentJson["owner", "fbid"].string
                        let commentOwnerName = commentJson["owner", "name"].string
                        let newComment = Comment(pk: commentId, text: commentText, artwork: nil, owner_id: commentOwnerId, owner_name: commentOwnerName, time: commentTime)
                        comment?.append(newComment)
                    }
                    for (_, likeJson):(String, JSON) in json["likes"]{
                        let likeId = likeJson["id"].intValue
                        let likeTime = likeJson["created_by"].string
                        let likeOwnerId = likeJson["owner", "fbid"].string
                        let likeOwnerName = likeJson["owner", "name"].string
                        let newLike = Like(pk: likeId, artwork: nil, owner_id: likeOwnerId, owner_name: likeOwnerName, time: likeTime)
                        like?.append(newLike)
                    }
                    artwork?.append(Artwork(pk: artworkId, name: name, url: url, owner_id: owner_id, owner_name: owner_name, comment: comment, like: like, template_id: template_id, template_name: template_name))
                }
                userInfo = UserInfo(pk: pk, name: name, email: email, picture: nil, artwork: artwork)
                print(json)
                print(userInfo!)
                print(userInfo == nil)
                completeHandler(userInfo)
            case .failure(let error):
                print(error)
                completeHandler(nil)
            }
        }
    }
    
    func postComment(commentText: String, ownerId: String, artworkId: Int, completeHandler: @escaping (_ result: Bool)->()) {
        let parameter = [
            "text": commentText,
            "owner": ownerId,
            "artwork": artworkId
        ] as [String : Any]
        
        Alamofire.request(URL+"/api/comment", method: .post, parameters: parameter).validate().responseJSON{
            response in
            switch response.result {
            case .success:
                completeHandler(true)
            case .failure:
                completeHandler(false)
            }
        }
    }
    
    func postLike(ownerId: String, artworkId: Int, completeHandler: @escaping (_ result: Bool)->()) {
        let parameter = [
            "owner": ownerId,
            "artwork": artworkId
            ] as [String : Any]
        
        Alamofire.request(URL+"/api/like", method: .post, parameters: parameter).validate().responseJSON{
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
            "name": name!,
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
            }, usingThreshold: UInt64.init(), to: URL + "/api/artwork", method: .post, headers: nil, encodingCompletion: {
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
