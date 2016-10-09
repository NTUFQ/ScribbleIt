//
//  ViewController.swift
//  DrawingApp
//
//  Created by Malek T. on 6/15/15.
//  Copyright (c) 2015 Medigarage Studios LTD. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var opacitySlider: UISlider!
    @IBOutlet weak var brashWidthSlider: UISlider!
    @IBOutlet weak var colorSlideView: UIView!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!


    @IBAction func saveImage(_ sender: AnyObject) {
        if let image = self.imageView.image {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:withPotentialError:contextInfo:)), nil)
        }
    }

    @IBAction func changeOpacity(_ sender: UISlider) {
        self.opacity = CGFloat(sender.value)
    }
    

    @IBAction func changeBrashWidth(_ sender: UISlider) {
        self.lineWidth = CGFloat(sender.value)
    }


    @IBAction func chooseColor(_ sender: AnyObject) {
        print(sender.tag)
        if(sender.tag > 0 && sender.tag < fixColors.count){
            (red, green, blue) = fixColors[sender.tag]
        }
        else{
            (red, green, blue) = fixColors[0]
        }
    }

    @IBAction func clearImage(_ sender: UIButton) {
        // save current image for undo
        if imageList.count < 5 {
            imageList.append(self.imageView.image)
            undoList.removeAll()
        }
        else{
            imageList.removeFirst();
            imageList.append(self.imageView.image)
            undoList.removeAll()
        }
        undoButton.isEnabled = true
        redoButton.isEnabled = false
        self.imageView.image = nil
        self.imageView.layer.sublayers = nil
        self.tempImageView.image = nil
        self.tempImageView.layer.sublayers = nil
    }
    @IBAction func chooseTool(_ sender: UIButton) {
        self.tool = sender.tag
    }
    
    @IBAction func undo(_ sender: UIButton) {
        if !imageList.isEmpty {
            undoList.append(self.imageView.image)
            redoButton.isEnabled = true
            self.imageView.image = imageList.popLast()!
            if imageList.isEmpty {
                undoButton.isEnabled = false
            }
        }
    }
    
    @IBAction func redo(_ sender: UIButton) {
        if !undoList.isEmpty {
            imageList.append(self.imageView.image)
            undoButton.isEnabled = true
            self.imageView.image = undoList.popLast()!
            if undoList.isEmpty {
                redoButton.isEnabled = false
            }
        }
    }
    
    var lastPoint:CGPoint!
    var isSwiping:Bool!
    var red:CGFloat = (0.0/255.0)
    var green:CGFloat = (0.0/255.0)
    var blue:CGFloat = (0.0/255.0)
    var lineWidth:CGFloat = 9.0
    var opacity:CGFloat = 1.0
    var tool: Int = 0
    var keyboardHeight = 450
    let fixColors : [(CGFloat, CGFloat, CGFloat)] = [
        (0, 0, 0),
        (0, 0, 0),
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
    var imageList = [UIImage?]()
    var undoList = [UIImage?]()
    
    
    func image(image: UIImage, withPotentialError error: NSErrorPointer, contextInfo: UnsafeRawPointer) {
        UIAlertView(title: nil, message: "Image successfully saved to Photos library", delegate: nil, cancelButtonTitle: "Dismiss").show()
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        red = (0.0/255.0)
        green = (0.0/255.0)
        blue = (0.0/255.0)
        redoButton.isEnabled = false
        undoButton.isEnabled = false
        //////test//////
        let api = API()
        api.getArtwork(pk: 5){
            atk in
            print("success")
            print(atk!.pk)
            print(atk!.comment)
            }
        //////test end///////

        
        let colorSlider = ColorSlider()
        colorSlider.frame = CGRect(x: 0, y: 0, width: 50, height: 200)
        colorSlideView.addSubview(colorSlider)
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
    
    func generatePath(tool: Int, lastpoint: CGPoint, currentPoint: CGPoint) -> UIBezierPath? {
        let center = CGPoint(x: (lastPoint.x + currentPoint.x)/2, y: (lastPoint.y + currentPoint.y)/2)
        switch tool {
        case 10: // circle
            let radius = hypot(currentPoint.x - lastPoint.x, currentPoint.y - lastPoint.y)/2
            return UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(0), endAngle: CGFloat(M_PI*2), clockwise: true)
        case 11: // square
            return UIBezierPath(rect: CGRect(x: lastPoint.x, y: lastPoint.y, width: (currentPoint.x-lastPoint.x), height: (currentPoint.y-lastPoint.y)))
        case 12: // oval
            return UIBezierPath(ovalIn: CGRect(x: lastPoint.x, y: lastPoint.y, width: (currentPoint.x-lastPoint.x), height: (currentPoint.y-lastPoint.y)))
        case 13: // star
            let radius = hypot(currentPoint.x - lastPoint.x, currentPoint.y - lastPoint.y)/2
            return drawStarBezier(x: center.x, y: center.y, radius: radius, sides: 5, pointyness: 2)
        default:
            return nil
        }
    }
    
    func drawPath(path: UIBezierPath) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor(red: red, green: green, blue: blue, alpha: opacity).cgColor
        shapeLayer.fillColor = UIColor(red: red, green: green, blue: blue, alpha: opacity).cgColor
        shapeLayer.lineWidth = lineWidth
        return shapeLayer
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isSwiping = false
        if let touch = touches.first{
            lastPoint = touch.location(in: imageView)
            
        }
//        if tool == 3 { //text tool
//            if let touch = touches.first {
//                let currentPoint = touch.location(in: self.view)
//                let text: UITextField = UITextField(frame: CGRect(x: currentPoint.x, y: CGFloat(keyboardHeight) + 30, width: 150, height: 30))
//                self.view.addSubview(text)
//                text.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: opacity)
//                text.keyboardType = UIKeyboardType.default
//                text.clearButtonMode = UITextFieldViewMode.whileEditing
//                text.placeholder = "text here"
//                text.returnKeyType = UIReturnKeyType.done
//                text.becomeFirstResponder()
//                
//            }
//        }
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
        else if tool >= 10 { //shape tool
            if let touch = touches.first {
                tempImageView.layer.sublayers = nil
                if let path = generatePath(tool: tool, lastpoint: lastPoint, currentPoint: touch.location(in: imageView)) {
                    let layer = drawPath(path: path)
                    self.tempImageView.layer.addSublayer(layer)
                }
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
        else if tool >= 10 {
            if let touch = touches.first {
                tempImageView.layer.sublayers = nil
                if let path = generatePath(tool: tool, lastpoint: lastPoint, currentPoint: touch.location(in: imageView)) {
                    let layer = drawPath(path: path)
                    UIGraphicsBeginImageContext(self.imageView.frame.size)
                    layer.render(in: UIGraphicsGetCurrentContext()!)
                    let image = UIGraphicsGetImageFromCurrentImageContext()
                    self.tempImageView.image = image
                    UIGraphicsEndImageContext()
                }
            }
        }
        
        // save current image for undo
        if imageList.count < 5 {
            imageList.append(self.imageView.image)
            undoList.removeAll()
        }
        else{
            imageList.removeFirst();
            imageList.append(self.imageView.image)
            undoList.removeAll()
        }
        undoButton.isEnabled = true
        redoButton.isEnabled = false
        
        // render image
        UIGraphicsBeginImageContext(self.imageView.frame.size)
        self.imageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.imageView.frame.size.width, height: self.imageView.frame.size.height), blendMode: CGBlendMode.normal, alpha: 1.0)
        self.tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.imageView.frame.size.width, height: self.imageView.frame.size.height), blendMode: CGBlendMode.normal, alpha: opacity)
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.tempImageView.image = nil
        self.tempImageView.layer.sublayers = nil
    }
    
    
    
    
    
    
    //implement draw star
    func degree2radian(a:CGFloat)->CGFloat {
        let b = CGFloat(M_PI) * a/180
        return b
    }
    
    func polygonPointArray(sides:Int,x:CGFloat,y:CGFloat,radius:CGFloat,adjustment:CGFloat=0)->[CGPoint] {
        let angle = degree2radian(a: 360/CGFloat(sides))
        let cx = x // x origin
        let cy = y // y origin
        let r  = radius // radius of circle
        var i = sides
        var points = [CGPoint]()
        while points.count <= sides {
            let xpo = cx - r * cos(angle * CGFloat(i)+degree2radian(a: adjustment))
            let ypo = cy - r * sin(angle * CGFloat(i)+degree2radian(a: adjustment))
            points.append(CGPoint(x: xpo, y: ypo))
            i -= 1
        }
        return points
    }
    
    func starPath(x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, pointyness:CGFloat) -> CGPath {
        let adjustment = 360/sides/2
        let path = CGMutablePath()
        let points = polygonPointArray(sides: sides,x: x,y: y,radius: radius)
        let cpg = points[0]
        let points2 = polygonPointArray(sides: sides,x: x,y: y,radius: radius*pointyness,adjustment:CGFloat(adjustment))
        var i = 0
        path.move(to: cpg)
        for p in points {
            path.addLine(to: points2[i])
            path.addLine(to: p)
            i += 1
        }
        path.closeSubpath()
        return path
    }
    
    func drawStarBezier(x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, pointyness:CGFloat)->UIBezierPath {
        let path = starPath(x: x, y: y, radius: radius, sides: sides, pointyness: pointyness)
        let bez = UIBezierPath(cgPath: path)
        return bez
    }
    // end of drawing star
}

