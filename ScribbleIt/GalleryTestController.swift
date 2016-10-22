//
//  GalleryTestController.swift
//  ScribbleIt
//
//  Created by Jacqueline Lee on 22/10/16.
//  Copyright © 2016 Fu Qiang. All rights reserved.
//

import UIKit
import Photos

class GalleryTestController: UICollectionViewController {
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupCollectionView()
//    }
    
//    func grabPhotos() {
//        
//        let imgManager = PHImageManager.default()
//        
//        let requestOptions = PHImageRequestOptions()
//        requestOptions.isSynchronous = true
//        requestOptions.deliveryMode = .fastFormat
//        
//        let fetchOptions = PHFetchOptions()
//        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//        
//        if let fetchResult : PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions) {
//            
//            if fetchResult.count > 0 {
//                
//                for i in 0..<fetchResult.count{
//                    
//                    imgManager.requestImage(for: fetchResult.objects(at: i), targetSize: <#T##CGSize#>(width: 200, height: 200), contentMode: .AspectFill , options: requestOptions, resultHandler: {
//                        
//                        image, error in
//                        
//                    })
//                    
//                }
//                
//            } else {
//                print ("you haven't drawn!")
//            }
//            
//        }
//        
//    }
    
    
//    func setupCollectionView() {
//        let layout = UICollectionViewFlowLayout()
//        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
//        collectionView?.backgroundColor = UIColor.green
//        view.addSubview(collectionView)
//    }
//    
    
}
