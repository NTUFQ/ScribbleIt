//
//  TemplateCollectionViewController.swift
//  ScribbleIt
//
//  Created by Fu Qiang on 10/15/16.
//  Copyright © 2016 Fu Qiang. All rights reserved.
//

import UIKit



class Template{
    var id: Int
    var name: String
    var image: UIImage?
    init(id: Int, name: String, image: UIImage?) {
        self.id = id
        self.name = name
        self.image = image
    }
}

protocol SelectTemplateDelegate {
    func selectTemplate(template: Template?)
}

class TemplateCollectionViewController: UICollectionViewController {
    private let reuseIdentifier = "TemplateCell"
    var selectTemplateDelegate: SelectTemplateDelegate? = nil
    let templates: [Template?] =
        [Template(id: 1, name: "template sample", image: UIImage(named: "pencil_black")),
         Template(id: 2, name: "Diamond", image: UIImage(named: "template2")),
         Template(id: 3, name: "template sample3", image: UIImage(named: "pencil_black")),
         Template(id: 4, name: "template sample4", image: UIImage(named: "pencil_black"))
                                 ]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        print(templates)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

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
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return templates.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TemplateCollectionViewCell
        // Configure the cell
        if let template = templates[indexPath.item]{
            cell.image.image = template.image
            cell.nameLabel.text = template.name
        }

        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let template = templates[indexPath.item]
        if (selectTemplateDelegate != nil) {
            self.selectTemplateDelegate?.selectTemplate(template: template)
            self.navigationController!.popViewController(animated: true)
        }
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
