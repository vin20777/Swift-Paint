//
//  GPBDesignableSlider.swift
//  GraffitiPaperBall
//
//  Created by 曹宇廷16924 on 2017/6/7.
//  Copyright © 2017年 Vincent Vangoh. All rights reserved.
//

import UIKit

@IBDesignable
class GPBDesignableSlider: UISlider {

    @IBInspectable var thumbImage: UIImage? {
        didSet {
            setThumbImage(thumbImage, for: .normal)
        }
    }
    
    @IBInspectable var thumbHighlightedImage: UIImage? {
        didSet {
            setThumbImage(thumbHighlightedImage, for: .highlighted)
        }
    }
    
}
