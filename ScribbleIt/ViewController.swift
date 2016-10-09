//
//  ViewController.swift
//  DrawingApp
//
//  Created by Malek T. on 6/15/15.
//  Copyright (c) 2015 Medigarage Studios LTD. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var opacitySlider: UISlider!
    @IBOutlet weak var brashWidthSlider: UISlider!
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var ColorSlideView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBAction func saveImage(_ sender: AnyObject) {
        if let image = self.imageView.image {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:withPotentialError:contextInfo:)), nil)
        }
    }
    
    @IBAction func OpacityChanged(_ sender: UISlider) {
        self.opacity = CGFloat(sender.value)
    }
    @IBAction func BrashWidthChanged(_ sender: UISlider) {
        self.lineWidth = CGFloat(sender.value)
    }
    @IBAction func ChooseColor(_ sender: UIButton) {
        print(sender.tag)
        if(sender.tag > 0 && sender.tag < fixColors.count){
            (red, green, blue) = fixColors[sender.tag]
        }
        else{
            (red, green, blue) = fixColors[0]
        }
        
    }
    
    var lastPoint:CGPoint!
    var isSwiping:Bool!
    var red:CGFloat = (0.0/255.0)
    var green:CGFloat = (0.0/255.0)
    var blue:CGFloat = (0.0/255.0)
    var lineWidth:CGFloat = 9.0
    var opacity:CGFloat = 1.0
    var tool: Int = 1
    var keyboardHeight = 450
    let fixColors : [(CGFloat, CGFloat, CGFloat)] = [
        (0, 0, 0),
        (255.0 / 255.0, 105.0 / 255.0, 105.0 / 255.0),
        (1.0, 0, 0),
        (0, 0, 1.0),
        (51.0 / 255.0, 204.0 / 255.0, 1.0),
        (102.0 / 255.0, 204.0 / 255.0, 0),
        (102.0 / 255.0, 1.0, 0),
        (160.0 / 255.0, 82.0 / 255.0, 45.0 / 255.0),
        (1.0, 102.0 / 255.0, 0),
        (1.0, 1.0, 0),
        (1.0, 1.0, 1.0),
        ]
    
    func image(image: UIImage, withPotentialError error: NSErrorPointer, contextInfo: UnsafeRawPointer) {
        UIAlertView(title: nil, message: "Image successfully saved to Photos library", delegate: nil, cancelButtonTitle: "Dismiss").show()
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    }
    
    
    @IBAction func undoDrawing(_ sender: AnyObject) {
        self.imageView.image = nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        red = (0.0/255.0)
        green = (0.0/255.0)
        blue = (0.0/255.0)
        let colorSlider = ColorSlider()
        colorSlider.frame = CGRect(x: 0, y: 0, width: 50, height: 200)
        ColorSlideView.addSubview(colorSlider)
        colorSlider.addTarget(self, action: #selector(changedColor(slider:)), for: .valueChanged)
        colorSlider.previewEnabled = true
        //colorSlider.orientation = .horizontal
        colorSlider.borderWidth = 2.0
        colorSlider.borderColor = UIColor.white
    }
    
    func changedColor(slider: ColorSlider) {
        slider.color.getRed(&red, green: &green, blue: &blue, alpha: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isSwiping = false
        if let touch = touches.first{
            lastPoint = touch.location(in: imageView)
            
        }
        if tool == 3 { //text tool
            if let touch = touches.first {
                let currentPoint = touch.location(in: self.view)
                let text: UITextField = UITextField(frame: CGRect(x: currentPoint.x, y: CGFloat(keyboardHeight) + 30, width: 150, height: 30))
                self.view.addSubview(text)
                text.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: opacity)
                text.keyboardType = UIKeyboardType.default
                text.clearButtonMode = UITextFieldViewMode.whileEditing
                text.placeholder = "text here"
                text.returnKeyType = UIReturnKeyType.done
                text.becomeFirstResponder()
                
            }
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = Int(keyboardSize.height)
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        isSwiping = true
        if tool == 0 {
            if let touch = touches.first {
                let currentPoint = touch.location(in: imageView)
                UIGraphicsBeginImageContext(self.imageView.frame.size)
                self.tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.imageView.frame.size.width, height: self.imageView.frame.size.height))//, blendMode: CGBlendMode.normal, alpha: opacity)
                let currentContext = UIGraphicsGetCurrentContext();
                currentContext?.move(to: lastPoint)
                currentContext?.addLine(to: currentPoint)
                currentContext?.setLineCap(CGLineCap.round)
                currentContext?.setLineWidth(lineWidth)
                currentContext?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
                currentContext?.strokePath()
                self.tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
                self.tempImageView.alpha = opacity
                UIGraphicsEndImageContext()
                lastPoint = currentPoint
            }
        }
        else if tool == 1 { //shape tool
            if let touch = touches.first {
                tempImageView.layer.sublayers = nil
                let currentPoint = touch.location(in: imageView)
                let center = CGPoint(x: (lastPoint.x + currentPoint.x)/2, y: (lastPoint.y + currentPoint.y)/2)
                
                let radius = hypot(currentPoint.x - lastPoint.x, currentPoint.y - lastPoint.y)/2
                let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(0), endAngle: CGFloat(M_PI*2), clockwise: true)
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = circlePath.cgPath
                shapeLayer.fillColor = UIColor(red: red, green: green, blue: blue, alpha: opacity).cgColor
                shapeLayer.strokeColor = UIColor(red: red, green: green, blue: blue, alpha: opacity).cgColor
                shapeLayer.lineWidth = lineWidth
                tempImageView.layer.addSublayer(shapeLayer)
                
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if tool == 0 {
            if(!isSwiping){
                UIGraphicsBeginImageContext(self.imageView.frame.size)
                self.tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.imageView.frame.size.width, height: self.imageView.frame.size.height), blendMode: CGBlendMode.normal, alpha: opacity)
                let currentContext = UIGraphicsGetCurrentContext();
                currentContext?.setLineCap(CGLineCap.round)
                currentContext?.setLineWidth(lineWidth)
                currentContext?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
                currentContext?.move(to: lastPoint)
                currentContext?.addLine(to: lastPoint)
                currentContext?.strokePath()
                self.tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
                self.tempImageView.alpha = opacity
                UIGraphicsEndImageContext()
            }
        }
        else if tool == 1 {
            if let touch = touches.first {
                tempImageView.layer.sublayers = nil
                let currentPoint = touch.location(in: imageView)
                let center = CGPoint(x: (lastPoint.x + currentPoint.x)/2, y: (lastPoint.y + currentPoint.y)/2)
                
                let radius = hypot(currentPoint.x - lastPoint.x, currentPoint.y - lastPoint.y)/2
                let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(0), endAngle: CGFloat(M_PI*2), clockwise: true)
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = circlePath.cgPath
                
                shapeLayer.strokeColor = UIColor(red: red, green: green, blue: blue, alpha: opacity).cgColor
                shapeLayer.fillColor = UIColor(red: red, green: green, blue: blue, alpha: opacity).cgColor
                shapeLayer.lineWidth = lineWidth
                self.imageView.layer.addSublayer(shapeLayer)
                
            }
        }
        UIGraphicsBeginImageContext(self.imageView.frame.size)
        self.imageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.imageView.frame.size.width, height: self.imageView.frame.size.height), blendMode: CGBlendMode.normal, alpha: 1.0)
        self.tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.imageView.frame.size.width, height: self.imageView.frame.size.height), blendMode: CGBlendMode.normal, alpha: opacity)
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.tempImageView.image = nil
    }
    
    
}

