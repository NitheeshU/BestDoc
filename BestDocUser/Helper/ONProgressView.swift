//
//  ONProgressView.swift
//  Offer9
//
//  Created by Focaloid Technologies on 17/04/17.
//  Copyright © 2017 Focaloid Technologies. All rights reserved.
//

import Foundation
import UIKit

func whitespaceValidation(_ name:String) -> Bool
{
    let whitespaceSet = CharacterSet.whitespaces
    if !name.trimmingCharacters(in: whitespaceSet).isEmpty
    {
        return true
    }
    else
    {
        return false
    }
}
class ProgressHUD: UIVisualEffectView {    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    let label: UILabel = UILabel()
    let blurEffect = UIBlurEffect(style: .light)
    let vibrancyView: UIVisualEffectView
    
    init(text: String) {
        self.text = text
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(effect: blurEffect)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.text = ""
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        contentView.addSubview(vibrancyView)
        contentView.addSubview(activityIndictor)
//        contentView.addSubview(label)
        activityIndictor.startAnimating()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()        
        if let superview = self.superview {
            self.frame = CGRect(x: superview.frame.size.width / 2 - 40,
                                y: superview.frame.height / 2 - 40,
                                width: 80,
                                height: 80)
            vibrancyView.frame = self.bounds
            vibrancyView.backgroundColor = UIColor.clear
            let activityIndicatorSize: CGFloat = 80
            activityIndictor.frame = CGRect(x: 0,
                                            y: 0,
                                            width: activityIndicatorSize,
                                            height: activityIndicatorSize)
            activityIndictor.color = UIColor(red: 1.0/255.0, green: 90.0/255.0, blue: 152.0/255.0, alpha: 1.0)
            var transform : CGAffineTransform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            activityIndictor.transform = transform
            layer.backgroundColor = UIColor.clear.cgColor
            layer.cornerRadius = 8.0
            layer.masksToBounds = true
        }
    }
    
    func show() {
        self.isHidden = false
    }
    
    func hide() {
        DispatchQueue.main.async {
        self.isHidden = true
        }
    }
}

//extension String {
//    var html2AttributedString: NSAttributedString? {
//        do {
//            return try NSAttributedString(data: Data(utf8), options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
//        } catch {
//            print(error)
//            return nil
//        }
//    }
//    var html2String: String {
//        return html2AttributedString?.string ?? ""
//    }
//}

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        return result
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension UIButton {
    func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        let writingDirection = UIApplication.shared.userInterfaceLayoutDirection
        let factor: CGFloat = writingDirection == .leftToRight ? 1 : -1
        
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount*factor, bottom: 0, right: insetAmount*factor)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount*factor, bottom: 0, right: -insetAmount*factor)
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
}
