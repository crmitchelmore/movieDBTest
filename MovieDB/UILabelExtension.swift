//
//  UILabelExtension.swift
//  MovieDB
//
//  Created by Chris Mitchelmore on 17/08/2017.
//  Copyright © 2017 Marks and Spencer. All rights reserved.
//

import UIKit

extension UILabel {
  var numberOfVisibleLines: Int {
    let textSize = CGSize(width: CGFloat(self.frame.size.width), height: CGFloat(MAXFLOAT))
    let rHeight: Int = lroundf(Float(self.sizeThatFits(textSize).height))
    let charSize: Int = lroundf(Float(self.font.pointSize))
    return rHeight / charSize
  }
}
