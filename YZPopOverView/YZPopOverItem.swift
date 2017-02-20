//
//  YZPopOverItem.swift
//  BatourTool
//
//  Created by iOS_Dev5 on 2017/2/15.
//  Copyright © 2017年 GRSource. All rights reserved.
//

import UIKit

class YZPopOverItem: NSObject {

    var image: UIImage?
    var title: String!
    var target: AnyObject?
    var action: Selector?
    var foreColor: UIColor?
    var alignment: NSTextAlignment?
    class func item(_ title: String, image: UIImage?, target: AnyObject?, action: Selector?) -> YZPopOverItem {
        return YZPopOverItem.init(title, image: image, target: target, action: action)
    }
    
    init(_ title: String, image: UIImage?, target: AnyObject?, action: Selector?) {
        super.init()
        self.title = title
        self.image = image
        self.target = target
        self.action = action
    }
    
    func enabled() -> Bool {
        return target != nil && action != nil
    }
    
    func performAction() {
        if action == nil {
            return
        }
        let target = self.target
        if target != nil && target!.responds(to: action!) {
            target?.performSelector(onMainThread: action!, with: self, waitUntilDone: true)
        }
    }
    
}
