//
//  GPBFineTuneViewController.swift
//  GraffitiPaperBall
//
//  Created by Vincent Vangoh on 2017/6/6.
//  Copyright © 2017年 Vincent Vangoh. All rights reserved.
//

import UIKit

protocol GPBFineTuneViewControllerDelegate: class {
    func GPBFineTuneViewControllerFinished(_ fineTuneViewController: GPBFineTuneViewController)
}

class GPBFineTuneViewController: GPBBaseViewController {

    @IBOutlet weak var sliderBrush: UISlider!
    @IBOutlet weak var sliderOpacity: UISlider!
    
    @IBOutlet weak var imageViewBrushOpacity: UIImageView!
    
    @IBOutlet weak var labelBrush: UILabel!
    @IBOutlet weak var labelOpacity: UILabel!
    
    @IBOutlet weak var sliderRed: UISlider!
    @IBOutlet weak var sliderGreen: UISlider!
    @IBOutlet weak var sliderBlue: UISlider!
    
    @IBOutlet weak var labelRed: UILabel!
    @IBOutlet weak var labelGreen: UILabel!
    @IBOutlet weak var labelBlue: UILabel!
    
    //預設值
    var brush: CGFloat = 60.0
    var opacity: CGFloat = 1.0
    var red: CGFloat = 248.0
    var green: CGFloat = 209.0
    var blue: CGFloat = 110.0
    
    weak var delegate: GPBFineTuneViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func close(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        self.delegate?.GPBFineTuneViewControllerFinished(self)
    }
    
    @IBAction func colorChanged(_ sender: UISlider) {
        red = CGFloat(sliderRed.value / 255.0)
        labelRed.text = NSString(format: "%d", Int(sliderRed.value)) as String
        green = CGFloat(sliderGreen.value / 255.0)
        labelGreen.text = NSString(format: "%d", Int(sliderGreen.value)) as String
        blue = CGFloat(sliderBlue.value / 255.0)
        labelBlue.text = NSString(format: "%d", Int(sliderBlue.value)) as String
        
        drawPreview()
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        if sender == sliderBrush {
            brush = CGFloat(sender.value)
            labelBrush.text = NSString(format: "%.2f", brush.native) as String
        } else {
            opacity = CGFloat(sender.value)
            labelOpacity.text = NSString(format: "%.2f", opacity.native) as String
        }
        
        drawPreview()
    }
    
    func drawPreview() {
        UIGraphicsBeginImageContext(imageViewBrushOpacity.frame.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setLineCap(.round)
        context?.setLineWidth(brush)
        
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: opacity)
        context?.move(to: CGPoint(x: 45.0, y: 45.0))
        context?.addLine(to: CGPoint(x: 45.0, y: 45.0))
        context?.strokePath()
        imageViewBrushOpacity.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sliderBrush.value = Float(brush)
        labelBrush.text = NSString(format: "%.1f", brush.native) as String
        sliderOpacity.value = Float(opacity)
        labelOpacity.text = NSString(format: "%.1f", opacity.native) as String
        sliderRed.value = Float(red * 255.0)
        labelRed.text = NSString(format: "%d", Int(sliderRed.value)) as String
        sliderGreen.value = Float(green * 255.0)
        labelGreen.text = NSString(format: "%d", Int(sliderGreen.value)) as String
        sliderBlue.value = Float(blue * 255.0)
        labelBlue.text = NSString(format: "%d", Int(sliderBlue.value)) as String
        
        drawPreview()
    }
}
