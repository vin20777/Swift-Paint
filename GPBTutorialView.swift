//
//  GPBTutorialView.swift
//  GraffitiPaperBall
//
//  Created by 曹宇廷16924 on 2017/6/8.
//  Copyright © 2017年 Vincent Vangoh. All rights reserved.
//

import UIKit

class GPBTutorialView: UIView {
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "GPBTutorialView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

}
