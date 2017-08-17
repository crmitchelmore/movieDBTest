//
//  UINavigationControllerExtension.swift
//  MovieDB
//
//  Created by Chris Mitchelmore on 17/08/2017.
//  Copyright © 2017 Marks and Spencer. All rights reserved.
//

import UIKit

extension UINavigationController {
  func showLoadingIndicator(_ show: Bool = true) {
    if show {
      let coverView = UIView(frame: view.frame)
      coverView.isUserInteractionEnabled = true
      coverView.backgroundColor = .black
      coverView.alpha = 0.10
      coverView.tag = 42
      let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
      indicator.startAnimating()
      coverView.addSubview(indicator)
      indicator.center = coverView.center
      view.addSubview(coverView)
    } else {
      view.subviews.forEach {
        if $0.tag == 42 {
          $0.removeFromSuperview()
        }
      }
    }
  }
}
