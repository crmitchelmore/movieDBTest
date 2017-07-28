//
//  UIImageViewExtension.swift
//  MovieDB
//
//  Created by Chris Mitchelmore on 27/07/2017.
//  Copyright © 2017 Marks and Spencer. All rights reserved.
//

import UIKit

extension UIImageView {

  func loadImageFromPath(_ path: String?) -> Cancelable? {
    if let path = path {
      return MovieDBServiceImplementation.shared.loadImagePath(path) { [weak self] image in
        DispatchQueue.main.async {
          self?.image = image
        }
      }
    }
    return nil
  }
  
}
