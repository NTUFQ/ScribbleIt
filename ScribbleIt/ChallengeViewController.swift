//
//  ChallengeViewController.swift
//  ScribbleIt
//
//  Created by Fu Qiang on 11/1/16.
//  Copyright © 2016 Fu Qiang. All rights reserved.
//

import UIKit

class ChallengeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
        print(segue.identifier)
        if segue.identifier == "ChallengeToDrawing" {
            print("chan")
            let drawingViewController = segue.destination as! DrawingViewController
            drawingViewController.template = Template(id: 999, name: "puppy", image:#imageLiteral(resourceName: "doggy"))
        }
    }
}
