//
//  extension.swift
//  BestDocUser
//
//  Created by nitheesh.u on 15/01/18.
//  Copyright © 2018 nitheesh.u. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView
{
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.prominent)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}
extension CALayer {
    func addBorder(edge: UIRectEdge, color: UIColor, width: CGFloat, thickness: CGFloat) {
        let border = CALayer()
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x:0, y:self.frame.height - thickness,width: width, height:thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x:0, y:0,width: thickness,height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x:self.frame.width - thickness,y:0, width:thickness, height:self.frame.height)
            break
        default:
            break
        }
        border.backgroundColor = color.cgColor;
        self.addSublayer(border)
    }
}
extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadowColor(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
extension String
{
    func utf8EncodedString()-> String {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8)
        return text!
    }
}
extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resizedTo1MB() -> UIImage? {
        guard let imageData = UIImagePNGRepresentation(self) else { return nil }
        
        var resizingImage = self
        var imageSizeKB = Double(imageData.count) / 1024.0
        
        while imageSizeKB > 1024 {
            guard let resizedImage = resizingImage.resized(withPercentage: 0.9),
                let imageData = UIImagePNGRepresentation(resizedImage)
                else { return nil }
            resizingImage = resizedImage
            imageSizeKB = Double(imageData.count) / 1024.0
        }
        return resizingImage
    }
}

//extension UIImageView {
//    
//    func setRounded() {
//        let radius = CGRect.width(self.frame) / 2
//        self.layer.cornerRadius = radius
//        self.layer.masksToBounds = true
//    }
//}

