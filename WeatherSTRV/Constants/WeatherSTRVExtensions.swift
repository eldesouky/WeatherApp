//
//  WeatherSTRVExtensions.swift
//  WeatherSTRV
//
//  Created by Mahmoud Eldesouky on 6/16/17.
//  Copyright © 2017 Mahmoud Eldesouky. All rights reserved.
//

import UIKit

//MARK:- Float
//MARK: Float+format
extension Float {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

//MARK:- Date
//MARK: Date+dayOfWeek
extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}

//MARK:- UIButton
//MARK: UIButton+loadingIndicator
extension UIButton {
    func loadingIndicator(show: Bool) {
        let tag = 898989
        if show {
            self.isEnabled = false
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.color = UIColor.gray
            indicator.tag = tag
            indicator.hidesWhenStopped = true
            self.titleLabel?.removeFromSuperview()
            self.imageView?.removeFromSuperview()
            self.addSubview(indicator)
            self.bringSubview(toFront: indicator)
            indicator.startAnimating()
        } else {
            self.isEnabled = true
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
                if let titleLabel = titleLabel{
                    self.addSubview(titleLabel)
                }
                if let imageView = imageView{
                    self.addSubview(imageView)
                }
            }
        }
    }
}
