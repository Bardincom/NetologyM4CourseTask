//
//  ActivityIndicator.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 08.05.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//
// ActivityIndicator взят из это статьи:
// https://prograils.com/posts/reusable-activity-indicator-with-swift

import Foundation
import UIKit

/// Индикатор загрузки
public class ActivityIndicator {
    static var activityIndicator: UIActivityIndicatorView?
    static var style: UIActivityIndicatorView.Style = .white
    static var baseBackColor = UIColor(white: 0, alpha: 0.7)
    static var baseColor = UIColor.white
    
   
    static func start(style: UIActivityIndicatorView.Style = style, backColor: UIColor = baseBackColor, baseColor: UIColor = baseColor) {
        DispatchQueue.main.async {
              if activityIndicator == nil, let window = UIApplication.shared.keyWindow {
                      let frame = UIScreen.main.bounds
                      activityIndicator = UIActivityIndicatorView(frame: frame)
                      
                      activityIndicator?.backgroundColor = backColor
                      activityIndicator?.style = style
                      activityIndicator?.color = baseColor
                      window.addSubview(activityIndicator!)
                      activityIndicator?.startAnimating()
                  }
        }
      
    }
    
    static func stop() {
        if activityIndicator != nil {
            activityIndicator?.stopAnimating()
            activityIndicator?.removeFromSuperview()
            activityIndicator = nil
        }
    }
    
    @objc static func update() {
        if activityIndicator != nil {
            stop()
            start()
        }
    }
}

