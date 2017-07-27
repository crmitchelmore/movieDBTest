//
//  UIImageViewExtension.swift
//  MovieDB
//
//  Created by Chris Mitchelmore on 27/07/2017.
//  Copyright © 2017 Marks and Spencer. All rights reserved.
//

import UIKit

protocol Cancelable {
  func cancel()
}
extension URLSessionDataTask: Cancelable {}
extension UIImageView {
//  static var imageLoadRequests: [String: URLSessionDataTask]
  
  
  func loadImageFromUrl(_ url: String) -> Cancelable {
//    self.image = UIImage()
    fatalError()
  }
  
}
