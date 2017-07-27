//
//  MovieViewModel.swift
//  MovieDB
//
//  Created by Chris Mitchelmore on 27/07/2017.
//  Copyright © 2017 Marks and Spencer. All rights reserved.
//

import Foundation

class MovieViewModel {
  
  let movie: Movie
  private let movieDBService = MovieDBService.shared
  private var allRelatedMovies: [MovieSummary]?
  
  init(movie: Movie) {
    self.movie = movie
  }
  
  var title: String {
    return movie.title ?? "No Title"
  }
  
  var popularity: String {
    return movie.popularity.flatMap { "Rating: \($0)" } ?? "No Rating"
  }
  
  var overview: String {
    return movie.overview ?? ""
  }
  
  var imageUrl: String? {
    return movie.posterPath
  }
  
  private var collectionId: String? {
    return movie.collection?.id.flatMap { "\($0)" }
  }
  
  var relatedMovies: [MovieSummaryViewModel] {
    guard let allRelatedMovies = allRelatedMovies else {
      return []
    }
    return allRelatedMovies.map {  MovieSummaryViewModel(movieSummary: $0) } ?? []
  }
  
  func loadRelatedMovies(_ completion: @escaping (Result<[MovieSummaryViewModel]>) -> Void) {
    guard let collectionId = collectionId else { return }
    movieDBService.getCollection(id: collectionId) { [weak self] result in
      switch result {
      case .success(let movieCollection):
        if let sSelf = self {
          sSelf.allRelatedMovies = movieCollection.parts
          completion(.success(sSelf.relatedMovies))
        }
      case .error(let error):
        completion(.error(error))
      }
      
    }
  }
}
