//
//  TNRAppUtils.swift
//  TreeNewsReader
//
//  Created by Vincent Vangoh on 2016/11/5.
//  Copyright © 2016年 VT Electronic Commerce Inc. All rights reserved.
//

import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

class TNRAppUtils: NSObject {
    
    //RGBA
    static func RGBwithAlpha(random: Bool, r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
        var rgbaColor:UIColor
        if (random) {
            rgbaColor = UIColor (red: CGFloat(arc4random_uniform(255))/255, green: CGFloat(arc4random_uniform(255))/255, blue: CGFloat(arc4random_uniform(255))/255, alpha: 0.5)
            return rgbaColor
        }
        rgbaColor = UIColor (red: r, green: g, blue: b, alpha: a)
        return rgbaColor
    }
    
    //Present the view controller on screen
    static func presentOnScreen(viewController: UIViewController) {
        
        var topController = UIApplication.shared.keyWindow?.rootViewController
        while ((topController?.presentedViewController) != nil) {
            topController = topController?.presentedViewController
        }
        topController?.present(viewController, animated: true, completion: nil)
    }
    
    static func addBlurView(view: UIView, style: UIBlurEffect.Style, alpha: CGFloat) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = alpha
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
}
