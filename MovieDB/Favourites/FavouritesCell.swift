//
//  FavouritesCell.swift
//  MovieDB
//
//  Created by Chris Mitchelmore on 27/07/2017.
//  Copyright © 2017 Marks and Spencer. All rights reserved.
//

import UIKit

class FavouritesCell: UITableViewCell {
  @IBOutlet var posterImageView: UIImageView?
  @IBOutlet var popularity: UILabel?
  @IBOutlet var title: UILabel?
  private var imageLoadRequest: Cancelable?
  
  func configureWith(title: String, imageUrl: String?, popularity: String?) {
    self.title?.text = title
    imageLoadRequest = posterImageView?.loadImageFromPath(imageUrl)
    self.popularity?.text = popularity
  }
  
  override func prepareForReuse() {
    imageLoadRequest?.cancel()
  }
}
