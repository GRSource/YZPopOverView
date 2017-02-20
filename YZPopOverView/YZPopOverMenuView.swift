//
//  YZPopOverMenuView.swift
//  BatourTool
//
//  Created by iOS_Dev5 on 2017/2/15.
//  Copyright © 2017年 GRSource. All rights reserved.
//

import UIKit

enum YZPopOverMenuViewArrowDirection : Int {
    case YZPopOverMenuViewArrowDirectionNone
    case YZPopOverMenuViewArrowDirectionUp
    case YZPopOverMenuViewArrowDirectionDown
    case YZPopOverMenuViewArrowDirectionLeft
    case YZPopOverMenuViewArrowDirectionRight
}

class YZPopOverMenuView: UIView {

    private var menuItems: [YZPopOverItem]!
    private var contentView: UIView?
    private let kArrowSize: CGFloat = 12
    private var arrowDirection: YZPopOverMenuViewArrowDirection?
    private var arrowPosition: CGFloat = 0
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear
//        self.isOpaque = true
        self.alpha = 0
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 2
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupFrameInView(_ view: UIView, fromRect: CGRect) {
        var contentSize = CGSize.zero
        if let tContentView = self.contentView {
            contentSize = tContentView.frame.size
        }
        let outerWidth = view.bounds.size.width
        let outerHeight = view.bounds.size.height
        let rectX0 = fromRect.origin.x
        let rectX1 = fromRect.origin.x + fromRect.size.width
        let rectXM = fromRect.origin.x + fromRect.size.width * 0.5
        let rectY0 = fromRect.origin.y
        let rectY1 = fromRect.origin.y + fromRect.size.height
        let rectYM = fromRect.origin.y + fromRect.size.height * 0.5
        
        let widthPlusArrow = contentSize.width + kArrowSize
        let heightPlusArrow = contentSize.height + kArrowSize
        let widthHalf = contentSize.width * 0.5
        let heightHalf = contentSize.height * 0.5
        
        let kMargin: CGFloat = 5//距离view的边距
        
        if heightPlusArrow < (outerHeight - rectY1) {
            
            arrowDirection = .YZPopOverMenuViewArrowDirectionUp
            var point = CGPoint(x: rectXM - widthHalf, y: rectY1)

            if point.x < kMargin {
                point.x = kMargin
            }
            
            if ((point.x + contentSize.width + kMargin) > outerWidth) {
                point.x = outerWidth - contentSize.width - kMargin
            }
            arrowPosition = rectXM - point.x;
            contentView?.frame = CGRect(x: 0, y: kArrowSize, width: contentSize.width, height: contentSize.height)
            
            self.frame = CGRect(x: point.x, y: point.y, width: contentSize.width, height: contentSize.height + kArrowSize)

        } else if heightPlusArrow < rectY0 {
            
            arrowDirection = .YZPopOverMenuViewArrowDirectionDown
            var point = CGPoint(x: rectXM - widthHalf, y: rectY0 - heightPlusArrow)

            if point.x < kMargin {
                point.x = kMargin
            }
            
            
            if (point.x + contentSize.width + kMargin) > outerWidth {
                point.x = outerWidth - contentSize.width - kMargin
            }
            arrowPosition = rectXM - point.x
            contentView?.frame = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
            
            self.frame = CGRect(x: point.x, y: point.y, width: contentSize.width, height: contentSize.height + kArrowSize)

            
        } else if widthPlusArrow < (outerWidth - rectX1) {
            
            arrowDirection = .YZPopOverMenuViewArrowDirectionLeft
            var point = CGPoint(x: rectX1, y: rectYM - heightHalf)

            
            if point.y < kMargin {
                point.y = kMargin
            }
            
            if (point.y + contentSize.height + kMargin) > outerHeight {
                point.y = outerHeight - contentSize.height - kMargin
            }
            arrowPosition = rectYM - point.y
            contentView?.frame = CGRect(x: kArrowSize, y: 0, width: contentSize.width, height: contentSize.height)
        
            self.frame = CGRect(x: point.x, y: point.y, width: contentSize.width + kArrowSize, height: contentSize.height)

            
        } else if widthPlusArrow < rectX0 {
            
            arrowDirection = .YZPopOverMenuViewArrowDirectionRight
            
            var point = CGPoint(x: rectX0 - widthPlusArrow, y: rectYM - heightHalf)
            
            if point.y < kMargin {
                point.y = kMargin
            }
            
            
            if (point.y + contentSize.height + 5) > outerHeight {
                point.y = outerHeight - contentSize.height - kMargin
            }
            arrowPosition = rectYM - point.y
            contentView?.frame = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
            
            self.frame = CGRect(x: point.x, y: point.y, width: contentSize.width  + kArrowSize, height: contentSize.height)

            
        } else {
            
            arrowDirection = .YZPopOverMenuViewArrowDirectionNone
            self.frame = CGRect(x: (outerWidth - contentSize.width)   * 0.5, y: (outerHeight - contentSize.height) * 0.5, width: contentSize.width, height: contentSize.height)
        }    

    }
    
    func showMenuInView(_ view: UIView, rect: CGRect, menuItems: [YZPopOverItem]) {
        self.menuItems = menuItems
        self.contentView = self.mkContentView()
        self.addSubview(self.contentView!)
        
        self.setupFrameInView(view, fromRect: rect)
        
        let overlay = YZPopOverlay(frame: view.bounds)
        overlay.addSubview(self)
        view.addSubview(overlay)
        
//        contentView?.isHidden = true
        let toFrame = self.frame
        self.frame = CGRect(x: self.arrowPoint().x, y: self.arrowPoint().y, width: 1, height: 1)
        let toContentFrame = self.contentView!.frame
        self.contentView?.frame = .zero
        weak var weakSelf = self
        UIView.animate(withDuration: 0.2, animations: {
            weakSelf?.alpha = 1
            weakSelf?.contentView?.frame = toContentFrame
            weakSelf?.frame = toFrame
            
        }) { (completed) in
//            self.contentView?.isHidden = false
        }
    }
    
    func dismissMenu(_ animated: Bool) {
        if self.superview != nil {
            if animated {
//                contentView?.isHidden = true
                let toFrame = CGRect(x: self.arrowPoint().x, y: self.arrowPoint().y, width: 1, height: 1)
                let toContentFrame = CGRect.zero
                weak var weakSelf = self
                UIView.animate(withDuration: 0.2, animations: {
                    weakSelf?.alpha = 0
                    weakSelf?.contentView?.frame = toContentFrame
                    weakSelf?.frame = toFrame
                }, completion: { (finished) in
                    if weakSelf != nil && weakSelf?.superview != nil && weakSelf!.superview!.isKind(of: YZPopOverlay.self) {
                        weakSelf!.superview!.removeFromSuperview()
                    }

                    weakSelf?.removeFromSuperview()
                })
            }else {
                if self.superview!.isKind(of: YZPopOverlay.self) {
                    self.superview?.removeFromSuperview()
                }
                self.removeFromSuperview()
            }
        }
    }

    private func mkContentView() -> UIView? {
        for v in self.subviews {
            v.removeFromSuperview()
        }
        if self.menuItems == nil || self.menuItems?.count == 0 {
            return nil
        }
        
        let kMinMenuItemHeight: CGFloat = 32
        let kMinMenuItemWidth: CGFloat = 32
//        let kMarginX: CGFloat = 10
        let kLeftMarginX: CGFloat = 10//左右两边的距离
        let kPaddingMarginX: CGFloat = 20//中间的距离
        let kMarginY: CGFloat = 5
        
        var titleFont = YZPopOverView.titleFont()
        if titleFont == nil {
            titleFont = UIFont.boldSystemFont(ofSize: 13)
        }
        
        var maxImageWidth: CGFloat = 0
        var maxItemHeight: CGFloat = 0
        var maxItemWidth: CGFloat = 0
        
        for menuItem in menuItems! {
            var imageSize: CGSize = .zero
            if let image = menuItem.image {
                imageSize = image.size
            }
            if imageSize.width > maxImageWidth {
                maxImageWidth = imageSize.width
            }
        }
        
//        if maxImageWidth != 0 {
//            maxImageWidth += kMarginX
//        }
        
        let attributes: [String: Any] = [NSFontAttributeName: titleFont!]
        for menuItem in menuItems {
            let titleSize: CGSize = (menuItem.title as NSString).size(attributes: attributes)
            var imageSize: CGSize = .zero
            if let image = menuItem.image {
                imageSize = image.size
            }
            let itemHeight = max(titleSize.height, imageSize.height) + kMarginY * 2
            let itemWidth = (!menuItem.enabled() && menuItem.image == nil) ? (titleSize.width + kLeftMarginX * 2) : (maxImageWidth + titleSize.width + kLeftMarginX * 2 + kPaddingMarginX)
            if itemHeight > maxItemHeight {
                maxItemHeight = itemHeight
            }
            if itemWidth > maxItemWidth {
                maxItemWidth = itemWidth
            }
        }
        
        maxItemWidth = max(maxItemWidth, kMinMenuItemWidth)
        maxItemHeight = max(maxItemHeight, kMinMenuItemHeight)
        
        let titleX = kLeftMarginX + maxImageWidth + kPaddingMarginX
        let titleWidth = maxItemWidth - titleX - kLeftMarginX
        
        let gradientHeight: CGFloat = 1//分割线高度
        let selectedImage = YZPopOverMenuView.selectedImage(CGSize(width: maxItemWidth, height: maxItemHeight))
        let gradientLine = YZPopOverMenuView.gradientLine(CGSize(width: maxItemWidth - kLeftMarginX * 2, height: gradientHeight))//设置分割线
        
        let contentView = UIView.init(frame: .zero)
//        contentView.autoresizingMask = .init(rawValue: 0)
        contentView.backgroundColor = .clear
//        contentView.isOpaque = false
        contentView.clipsToBounds = true
//        contentView.layer.cornerRadius = self.layer.cornerRadius
        var itemY: CGFloat = 0//item的起始Y坐标
        var itemNum: Int = 0
        
        for menuItem in menuItems {
            let itemFrame = CGRect(x: 0, y: itemY, width: maxItemWidth, height: maxItemHeight)
            
            let itemView = UIView.init(frame: itemFrame)
//            itemView.autoresizingMask = .init(rawValue: 0)
            itemView.backgroundColor = .clear
//            itemView.isOpaque = false
            
            contentView.addSubview(itemView)
            
            if menuItem.enabled() {
                let button = UIButton.init(type: .custom)
                button.tag = itemNum
                button.frame = itemView.bounds
                button.isEnabled = menuItem.enabled()
                button.backgroundColor = .clear
                button.clipsToBounds = true
//                button.isOpaque = false
//                button.autoresizingMask = .init(rawValue: 0)
                button.addTarget(self, action: #selector(performAction(_:)), for: .touchUpInside)
                button.setBackgroundImage(selectedImage, for: .highlighted)
                itemView.addSubview(button)
                if itemNum == 0 {
                    let maskPath = UIBezierPath(roundedRect: button.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 8, height: 8))
                    let maskLayer = CAShapeLayer()
                    maskLayer.frame = button.bounds
                    maskLayer.path = maskPath.cgPath
                    button.layer.mask = maskLayer
                }else if itemNum == menuItems.count - 1 {
                    let maskPath = UIBezierPath(roundedRect: button.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 8, height: 8))
                    let maskLayer = CAShapeLayer()
                    maskLayer.frame = button.bounds
                    maskLayer.path = maskPath.cgPath
                    button.layer.mask = maskLayer
                }
            }
            
            var titleFrame: CGRect = .zero
            if !menuItem.enabled() && menuItem.image == nil {
                titleFrame = CGRect(x: kLeftMarginX, y: kMarginY, width: maxItemWidth - kLeftMarginX * 2, height: maxItemHeight - kMarginY * 2)
            }else {
                titleFrame = CGRect(x: titleX, y: kMarginY, width: titleWidth, height: maxItemHeight - kMarginY * 2)
            }
            
            let titleLabel = UILabel(frame: titleFrame)
            titleLabel.text = menuItem.title
            titleLabel.font = titleFont
            titleLabel.textAlignment = menuItem.alignment != nil ? menuItem.alignment! : .center
            titleLabel.textColor = menuItem.foreColor != nil ? menuItem.foreColor! : .black
            titleLabel.backgroundColor = .clear
//            titleLabel.autoresizingMask = .init(rawValue: 0)
            itemView.addSubview(titleLabel)
            
            if menuItem.image != nil {
                let imageFrame = CGRect(x: kLeftMarginX, y: kMarginY, width: maxImageWidth, height: maxItemHeight - kMarginY * 2)
                let imageView = UIImageView(frame: imageFrame)
                imageView.image = menuItem.image
                imageView.clipsToBounds = true
                imageView.contentMode = .center
//                imageView.autoresizingMask = .init(rawValue: 0)
                itemView.addSubview(imageView)
            }
            
            if itemNum < menuItems.count - 1 {
                let gradientView = UIImageView(image: gradientLine)
                gradientView.frame = CGRect(x: kLeftMarginX, y: maxItemHeight + gradientHeight, width: gradientLine.size.width, height: gradientLine.size.height)
                gradientView.contentMode = .left
                itemView.addSubview(gradientView)
                itemY += gradientHeight
            }
            itemY += maxItemHeight
            itemNum += 1
        }
        
        contentView.frame = CGRect(x: 0, y: 0, width: maxItemWidth, height: itemY)
        return contentView
    }

    func arrowPoint() -> CGPoint {
        var point = CGPoint.zero
        if arrowDirection == .YZPopOverMenuViewArrowDirectionUp {
            point = CGPoint(x: self.frame.origin.x + arrowPosition, y: self.frame.origin.y)
        }else if arrowDirection == .YZPopOverMenuViewArrowDirectionDown {
            point = CGPoint(x: self.frame.origin.x + arrowPosition, y: self.frame.origin.y + self.frame.size.height)
        }else if arrowDirection == .YZPopOverMenuViewArrowDirectionLeft {
            point = CGPoint(x: self.frame.origin.x, y: self.frame.origin.y + arrowPosition)
        }else if arrowDirection == .YZPopOverMenuViewArrowDirectionRight {
            point = CGPoint(x: self.frame.origin.x + self.frame.size.width, y: self.frame.origin.y + arrowPosition)
        }else {
            point = self.center
        }
        return point
    }
    
    class func selectedImage(_ size: CGSize) -> UIImage {//绘制选中后的背景图片
        let locations: [CGFloat] = [0,1]
        let components: [CGFloat] = [0.851, 0.851, 0.851, 1,//选中每一项后的背景色，初始颜色
                          0.851, 0.851, 0.851, 1]//选中每一项后的背景色，渐变后的最大颜色值
        return self.gradientImageWithSize(size, locations: locations, components: components, count: locations.count)
    }

    class func gradientLine(_ size: CGSize) -> UIImage {//绘制分割线
        let locations: [CGFloat] = [0, 1]
        let R: CGFloat = 0.827
        let G: CGFloat = 0.827
        let B: CGFloat = 0.827//分割线颜色
        let components: [CGFloat] = [R, G, B, 1,
                                     R, G, B, 1]
        return self.gradientImageWithSize(size, locations: locations, components: components, count: locations.count)
    }
    
    class func gradientImageWithSize(_ size: CGSize, locations: [CGFloat], components: [CGFloat], count: Int) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorGradient = CGGradient.init(colorSpace: colorSpace, colorComponents: components, locations: locations, count: locations.count)
        context?.drawLinearGradient(colorGradient!, start: CGPoint(x: 0, y: 0), end: CGPoint(x: size.width, y: 0), options: .drawsBeforeStartLocation)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        return image!
    }
    
    
    override func draw(_ rect: CGRect) {
        self.drawBackground(self.bounds, context: UIGraphicsGetCurrentContext()!)
    }
    
    func drawBackground(_ frame: CGRect, context: CGContext) {
        var R0: CGFloat = 1, G0: CGFloat = 1, B0: CGFloat = 1//箭头背景色
        let R1: CGFloat = 1, G1: CGFloat = 1, B1: CGFloat = 1//箭头背景色
        
        let tintColor = YZPopOverView.tintColor()
        if tintColor != nil {
            var a: CGFloat = 0
            tintColor?.getRed(&R0, green: &G0, blue: &B0, alpha: &a)
        }

        var X0 = frame.origin.x
        var X1 = frame.origin.x + frame.size.width
        var Y0 = frame.origin.y
        var Y1 = frame.origin.y + frame.size.height
        
        // render arrow
        
        let arrowPath = UIBezierPath()
        
        // fix the issue with gap of arrow's base if on the edge
        let kEmbedFix:  CGFloat = 3
        
        if arrowDirection == .YZPopOverMenuViewArrowDirectionUp {
            
            let arrowXM = arrowPosition
            let arrowX0 = arrowXM - kArrowSize
            let arrowX1 = arrowXM + kArrowSize
            let arrowY0 = Y0
            let arrowY1 = Y0 + kArrowSize + kEmbedFix
            
            arrowPath.move(to: CGPoint(x: arrowXM, y: arrowY0))
            arrowPath.addLine(to: CGPoint(x: arrowX1, y: arrowY1))
            arrowPath.addLine(to: CGPoint(x: arrowX0, y: arrowY1))
            arrowPath.addLine(to: CGPoint(x: arrowXM, y: arrowY0))
            
            UIColor(red: R0, green: G0, blue: B0, alpha: 1).set()
            
            Y0 += kArrowSize
            
        } else if arrowDirection == .YZPopOverMenuViewArrowDirectionDown {
            
            let arrowXM = arrowPosition
            let arrowX0 = arrowXM - kArrowSize
            let arrowX1 = arrowXM + kArrowSize
            let arrowY0 = Y1 - kArrowSize - kEmbedFix
            let arrowY1 = Y1
            
            arrowPath.move(to: CGPoint(x: arrowXM, y: arrowY1))
            arrowPath.addLine(to: CGPoint(x: arrowX1, y: arrowY0))
            arrowPath.addLine(to: CGPoint(x: arrowX0, y: arrowY0))
            arrowPath.addLine(to: CGPoint(x: arrowXM, y: arrowY1))
            
            UIColor(red: R1, green: G1, blue: B1, alpha: 1).set()
            
            Y1 -= kArrowSize
            
        } else if arrowDirection == .YZPopOverMenuViewArrowDirectionLeft {
            
            let arrowYM = arrowPosition
            let arrowX0 = X0
            let arrowX1 = X0 + kArrowSize + kEmbedFix
            let arrowY0 = arrowYM - kArrowSize
            let arrowY1 = arrowYM + kArrowSize
            
            arrowPath.move(to: CGPoint(x: arrowX0, y: arrowYM))
            arrowPath.addLine(to: CGPoint(x: arrowX1, y: arrowY0))
            arrowPath.addLine(to: CGPoint(x: arrowX1, y: arrowY1))
            arrowPath.addLine(to: CGPoint(x: arrowX0, y: arrowYM))
            
            UIColor(red: R0, green: G0, blue: B0, alpha: 1).set()
            
            X0 += kArrowSize
            
        } else if arrowDirection == .YZPopOverMenuViewArrowDirectionRight {
            
            let arrowYM = arrowPosition
            let arrowX0 = X1
            let arrowX1 = X1 - kArrowSize - kEmbedFix
            let arrowY0 = arrowYM - kArrowSize
            let arrowY1 = arrowYM + kArrowSize
            
            arrowPath.move(to: CGPoint(x: arrowX0, y: arrowYM))
            arrowPath.addLine(to: CGPoint(x: arrowX1, y: arrowY0))
            arrowPath.addLine(to: CGPoint(x: arrowX1, y: arrowY1))
            arrowPath.addLine(to: CGPoint(x: arrowX0, y: arrowYM))
            
            UIColor(red: R1, green: G1, blue: B1, alpha: 1).set()
            
            X1 -= kArrowSize
        }
        
        arrowPath.fill()
        
        
        // render body
        
        let bodyFrame = CGRect(x: X0, y: Y0, width: X1 - X0, height: Y1 - Y0)
    

        let borderPath = UIBezierPath(roundedRect: bodyFrame, cornerRadius: 8)
        
        let locations: [CGFloat] = [0, 1]
        
        let components: [CGFloat] = [
            R0, G0, B0, 1,
            R1, G1, B1, 1,
        ]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient.init(colorSpace: colorSpace, colorComponents: components, locations: locations, count: MemoryLayout.size(ofValue: locations)/MemoryLayout.size(ofValue: locations[0]))
        
        borderPath.addClip()
        
        
        
        var start: CGPoint = .zero
        var end: CGPoint = .zero
        
        if arrowDirection == .YZPopOverMenuViewArrowDirectionLeft ||
            arrowDirection == .YZPopOverMenuViewArrowDirectionRight {
            
            start = CGPoint(x: X0, y: Y0)
            end = CGPoint(x: X1, y: Y0)
            
            
        } else {
            
            start = CGPoint(x: X0, y: Y0)
            end = CGPoint(x: X0, y: Y1)

        }
        context.drawLinearGradient(gradient!, start: start, end: end, options: .drawsBeforeStartLocation)
        
        
    }
    
    func performAction(_ sender: UIButton) {
        self.dismissMenu(false)
        let menuItem = menuItems[sender.tag]
        menuItem.performAction()
    }
}
