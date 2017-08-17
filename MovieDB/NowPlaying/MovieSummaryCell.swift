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
    contentView.translatesAutoresizingMaskIntoConstraints = false
    self.title?.text = title
    imageLoadRequest = imageView?.loadImageFromPath(imageUrl)
    
    if size.width > 0 {
      imageWidth.constant = size.width
    } else if size.height > 0 {
      let otherBitsHeight = 20 + self.title!.frame.size.height
      let imageHeight = size.height - otherBitsHeight
      imageWidth.constant = imageHeight / 4 * 3
    }
    layoutIfNeeded()
  }
  
  override func prepareForReuse() {
    imageLoadRequest?.cancel()
  }
}
