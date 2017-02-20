//
//  YZPopOverView.swift
//  BatourTool
//
//  Created by iOS_Dev5 on 2017/2/15.
//  Copyright © 2017年 GRSource. All rights reserved.
//

import UIKit

class YZPopOverView: NSObject {
    
    static let sharedInstance = YZPopOverView()
    private static var gTintColor: UIColor?
    private static var gTitleFont: UIFont?
    private var observing = false
    private var menuView: YZPopOverMenuView?
    
    
    class func showMenuInView(_ view: UIView, fromRect rect: CGRect, menuItems: [YZPopOverItem]) {
        self.sharedInstance.showMenuInView(view, fromRect: rect, menuItems: menuItems)
    }
    
    func showMenuInView(_ view: UIView, fromRect rect: CGRect, menuItems: [YZPopOverItem]) {
        if menuView != nil {
            menuView?.dismissMenu(false)
            menuView = nil
        }
        
        if !observing {
            observing = true
            NotificationCenter.default.addObserver(self, selector: #selector(orientationWillChange(_:)), name: NSNotification.Name.UIApplicationWillChangeStatusBarOrientation, object: nil)
            
        }
        
        menuView = YZPopOverMenuView()
        menuView?.showMenuInView(view, rect: rect, menuItems: menuItems)
    }
    
    func orientationWillChange(_ sender: Notification) {
        self.dismissMenu()
    }
    
    func dismissMenu() {
        if menuView != nil {
            menuView!.dismissMenu(false)
            menuView = nil
        }
        if observing {
            observing = false
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    class func dismissMenu() {
        self.sharedInstance.dismissMenu()
    }
    
    class func tintColor() -> UIColor? {
        return gTintColor
    }
    
    class func setTintColor(_ tintColor: UIColor) {
        gTintColor = tintColor
    }
    
    class func titleFont() -> UIFont? {
        return gTitleFont
    }
    
    class func setTitleFont(_ titleFont: UIFont) {
        gTitleFont = titleFont
    }
    
}
