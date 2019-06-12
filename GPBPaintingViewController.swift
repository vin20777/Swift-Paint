//
//  GPBPaintingViewController.swift
//  GraffitiPaperBall
//
//  Created by Vincent Vangoh on 2017/6/6.
//  Copyright © 2017年 Vincent Vangoh. All rights reserved.
//

import UIKit

class GPBPaintingViewController: GPBBaseViewController {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet var sideBarView: UIView!
    @IBOutlet var sbConstraint: NSLayoutConstraint!
    @IBOutlet var bottomStackView: UIStackView!
    @IBOutlet var botConstraint: NSLayoutConstraint!
    @IBOutlet var wrapButton: UIButton!
    
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    var expanse = false
    var tutorialView: GPBTutorialView!
    
    let colors: [(CGFloat, CGFloat, CGFloat)] = [
        (0, 0, 0),
        (105.0 / 255.0, 105.0 / 255.0, 105.0 / 255.0),
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.expandAll))
        tap.delegate = self as? UIGestureRecognizerDelegate
        tap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(tap)
        
        tutorialView = GPBTutorialView.instanceFromNib() as? GPBTutorialView
        tutorialView.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height)
        self.view.addSubview(tutorialView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.expanse == false {
            sbConstraint.constant = 0.0
            botConstraint.constant = 0.0
            
            UIView.animate(withDuration: 0.6,
                           delay: 0.0,
                           options: UIView.AnimationOptions.curveEaseIn,
                           animations: { () -> Void in
                            self.view.layoutIfNeeded()
            }, completion: { (finished) -> Void in
                self.expanse = true
            })
        }
    }
    
    // MARK: - Actions
    
    @objc func expandAll() {
        
        UIView.animate(withDuration: 0.6,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        
                        if self.expanse == true {
                            self.sbConstraint.constant = -50.0
                            self.botConstraint.constant = -100.0
                            self.wrapButton.alpha = 0.0
                        } else {
                            self.sbConstraint.constant = 0.0
                            self.botConstraint.constant = 0.0
                            self.wrapButton.alpha = 1.0
                        }
                        
                        self.view.layoutIfNeeded()
        }, completion: { (finished) -> Void in
            self.expanse = !self.expanse
        })
    }
    
    @IBAction func reset(_ sender: AnyObject) {
        mainImageView.image = nil
    }
    
    @IBAction func share(_ sender: AnyObject) {
        UIGraphicsBeginImageContext(mainImageView.bounds.size)
        mainImageView.image?.draw(in: CGRect(x: 0, y: 0,
                                             width: mainImageView.frame.size.width, height: mainImageView.frame.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let activity = UIActivityViewController(activityItems: [image as Any], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
    }
    
    @IBAction func pencilPressed(_ sender: AnyObject) {
        
        var index = sender.tag ?? 0
        if index < 0 || index >= colors.count {
            index = 0
        }
        
        (red, green, blue) = colors[index]
        
        if index == colors.count - 1 {
            opacity = 1.0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
        DispatchQueue.once(token: "Remove Tutorial") {
            tutorialView.removeFromSuperview()
        }
    }
    
    func drawLineFrom(_ fromPoint: CGPoint, toPoint: CGPoint) {
        
        // 1
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        // 2
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        
        // 3
        context?.setLineCap(.round)
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
        context?.setBlendMode(.normal)
        
        // 4
        context?.strokePath()
        
        // 5
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 6
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: view)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            // 7
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !swiped {
            // draw a single point
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        
        mainImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.normal, alpha: 1.0)
        
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempImageView.image = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let fineTuneViewController = segue.destination as! GPBFineTuneViewController
        fineTuneViewController.delegate = self
        fineTuneViewController.brush = brushWidth
        fineTuneViewController.opacity = opacity
        fineTuneViewController.red = red
        fineTuneViewController.green = green
        fineTuneViewController.blue = blue
    }
}

extension GPBPaintingViewController: GPBFineTuneViewControllerDelegate {

    func GPBFineTuneViewControllerFinished(_ fineTuneViewController: GPBFineTuneViewController) {
        self.brushWidth = fineTuneViewController.brush
        self.opacity = fineTuneViewController.opacity
        self.red = fineTuneViewController.red
        self.green = fineTuneViewController.green
        self.blue = fineTuneViewController.blue
    }
    
}

public extension DispatchQueue {
    
    private static var _onceTracker = [String]()

    class func once(token: String, block:()->Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        block()
    }
}
