//
//  MovieViewModel.swift
//  MovieDB
//
//  Created by Chris Mitchelmore on 27/07/2017.
//  Copyright © 2017 Marks and Spencer. All rights reserved.
//

import Foundation

class MovieViewModel {
  
  private let movie: Movie
  private let movieDBService: MovieDBService
  
  init(movie: Movie, movieDBService: MovieDBService) {
    self.movie = movie
    self.movieDBService = movieDBService
  }
}
