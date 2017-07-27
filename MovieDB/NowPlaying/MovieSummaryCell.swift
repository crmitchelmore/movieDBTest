//
//  MovieSummaryCell.swift
//  MovieDB
//
//  Created by Chris Mitchelmore on 27/07/2017.
//  Copyright © 2017 Marks and Spencer. All rights reserved.
//

import UIKit

class MovieSummaryCell: UICollectionViewCell {
  @IBOutlet var imageView: UIImageView?
  @IBOutlet var title: UILabel?
  private var imageLoadRequest: Cancelable?
  
  @IBOutlet weak var imageWidth: NSLayoutConstraint!
  func configureWith(title: String, imageUrl: String?, size: CGSize) {
    self.title?.text = title
    imageLoadRequest = imageView?.loadImageFromPath(imageUrl)
    imageWidth.constant = size.width
  }
  
  override func prepareForReuse() {
    title?.text = ""
    imageLoadRequest?.cancel()
  }
}
