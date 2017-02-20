//
//  YZPopOverlay.swift
//  BatourTool
//
//  Created by iOS_Dev5 on 2017/2/15.
//  Copyright © 2017年 GRSource. All rights reserved.
//

import UIKit

class YZPopOverlay: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
//        self.isOpaque = false
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(singleTap(_:)))
        self.addGestureRecognizer(gestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func singleTap(_ sender: UITapGestureRecognizer) {
        for v in self.subviews {
            if v.isKind(of: YZPopOverMenuView.self) {
                let tmpV = v as! YZPopOverMenuView
                tmpV.dismissMenu(true)
            }
        }
    }
    
}
