//
//  MovieSummaryViewModel.swift
//  MovieDB
//
//  Created by Chris Mitchelmore on 27/07/2017.
//  Copyright © 2017 Marks and Spencer. All rights reserved.
//

import Foundation

class MovieSummaryViewModel {
  private let movieSummary: MovieSummary
  
  init(movieSummary: MovieSummary) {
    self.movieSummary = movieSummary
  }
  
  var id: String? {
    return movieSummary.id.flatMap { "\($0)" }
  }
  
  var title: String {
    return movieSummary.title ?? "No Title"
  }
  
  var imageUrl: String? {
    return movieSummary.posterPath
  }
}
