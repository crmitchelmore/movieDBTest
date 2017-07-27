//
//  NowPlayingViewModel.swift
//  MovieDB
//
//  Created by Chris Mitchelmore on 27/07/2017.
//  Copyright © 2017 Marks and Spencer. All rights reserved.
//

import Foundation
enum FilterOperator {
  case greaterThan
  case lessThan
}

enum NowPlayingFilterOptions {
  case popularity(op: FilterOperator, value: Double)
}

enum NowPlayingSortByOptions {
  case popularityAscending
  case popularityDescending
}

extension NowPlayingFilterOptions {
  func includesMovie(_ movie: MovieSummary) -> Bool {
    guard let popularity = movie.popularity else {
      return false
    }
    switch self {
    case .popularity(let op, let value):
      switch op {
      case .greaterThan:
        return popularity > value
      case .lessThan:
        return popularity < value
      }
    }
  }
}

extension NowPlayingSortByOptions {
  
  private func popularityAsc(movies: [MovieSummary]) -> [MovieSummary] {
    return movies.sorted(by: { (lhs, rhs) -> Bool in
      guard let lhsPopularity = lhs.popularity, let rhsPopularity = rhs.popularity else {
        return false
      }
      return lhsPopularity < rhsPopularity
    })
  }
  
  func sortMovies(_ movies: [MovieSummary]) -> [MovieSummary] {
    switch self {
    case .popularityAscending:
      return popularityAsc(movies: movies)
    case .popularityDescending:
      return popularityAsc(movies: movies).reversed()
    }
  }
}

class NowPlayingViewModel {
  private let nowPlaying: NowPlaying
  private let movieDBService: MovieDBService
  
  private var currentFilter: NowPlayingFilterOptions?
  private var currentSortBy: NowPlayingSortByOptions?
  
  init(nowPlaying: NowPlaying, movieDBService: MovieDBService) {
    self.nowPlaying = nowPlaying
    self.movieDBService = movieDBService
  }
  
  func filterMoviesBy(_ filterBy: NowPlayingFilterOptions) {
    currentFilter = filterBy
  }
  
  func clearFilter() {
    currentFilter = nil
  }
  
  func sortMoviesBy(_ sortBy: NowPlayingSortByOptions) {
    currentSortBy = sortBy
  }
  
  func clearSortBy() {
    currentSortBy = nil
  }
  
  var moviesToDisplay: [MovieSummary] {
    var movieResults = nowPlaying.result
    if let currentFilter = currentFilter {
      movieResults = movieResults.filter { currentFilter.includesMovie($0) }
    }
    
    if let sortBy = currentSortBy {
      return sortBy.sortMovies(movieResults)
    }
    return movieResults
  }
  
  func refreshMovies(_ completion: (Result<NowPlayingViewModel>) -> Void) {
    movieDBService.getMovies { result in
      switch result {
      case .success(let nowPlaying):
        completion(.success(NowPlayingViewModel(nowPlaying: nowPlaying, movieDBService: self.movieDBService)))
      case .error(let error):
        completion(.error(error))
      }
    }
  }
  
  func movie(for movieSummary: MovieSummary, completion: @escaping (Result<MovieViewModel>) -> Void) {
    //ID! to verify
    movieDBService.getMovie(id: "\(movieSummary.id!)") { (result: Result<Movie>) in
      switch result {
      case .success(let movie):
        completion(.success(MovieViewModel(movie: movie, movieDBService: self.movieDBService)))
      case .error(let error):
        completion(.error(error))
      }
    }
  }
}