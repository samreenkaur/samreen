//
//  Extension.swift
//  Leave Management
//
//  Created by osx on 04/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController
{
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

extension UIView
{
    @IBInspectable var cornerRadius: Double {
        get {
            return Double(self.layer.cornerRadius)
        }set {
            self.layer.cornerRadius = CGFloat(newValue)
        }
    }
    @IBInspectable var borderWidth: Double {
        get {
            return Double(self.layer.borderWidth)
        }
        set {
            self.layer.borderWidth = CGFloat(newValue)
        }
    }
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    func addShadow(shadowColor: CGColor = Colors.themeShadow.cgColor,
                   shadowOffset: CGSize = CGSize(width: 0.5, height: 0.5),
                   shadowOpacity: Float = 0.8,
                   shadowRadius: CGFloat = 3.0) {
        self.layer.shadowColor = shadowColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.layer.masksToBounds = false
    }
}
extension UINavigationBar{
    @IBInspectable var transparentNavigationBar: Bool {
        get {
            return false
        }
        set {
            if newValue == true {
                self.transparentNavigationBar1()
            }
        }
    }
    
    func transparentNavigationBar1() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
}

extension String
{
    func convertStringToDate(dataFormat : String) -> Date?{
        let formatter = dateFormatter
        formatter.dateFormat = dataFormat
        let date = formatter.date(from: self)
        return date
    }
}
extension Date{
    func convertDateToString(dataFormat: String) -> String {
        let formatter = dateFormatter
        formatter.dateFormat = dataFormat//"dd MMM yyyy"
//        formatter.dateFormat = "dd MMM yyyy HH:mm a"
        let str = formatter.string(from: self)
        return str
    }
}
