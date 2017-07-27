//
//  MoviePersistanceService.swift
//  MovieDB
//
//  Created by Chris Mitchelmore on 27/07/2017.
//  Copyright © 2017 Marks and Spencer. All rights reserved.
//

import Foundation

class MoviePersistanceService {
  
  static let shared = MoviePersistanceService()
  private init() {}
  
  private let savedMoviesKey = "SavedMovies"
  private let defaults = UserDefaults.standard
  
  func addMovie(_ movieViewModel: MovieViewModel) -> Bool {
    var movies = self.savedModels
    guard !movies.contains(movieViewModel.movie) else { return true }
    movies.append(movieViewModel.movie)
    let encoder = JSONEncoder()
    do {
      let moviesData = try movies.map {
        try encoder.encode($0)
      }
      defaults.set(moviesData, forKey: savedMoviesKey)
    } catch {
      return false
    }
    return defaults.synchronize()
  }

  
  private var savedModels: [Movie] {
    if let movieData = defaults.array(forKey: savedMoviesKey) as? [Data] {
      let decoder = JSONDecoder()
      do {
        return try movieData.map {
          return try decoder.decode(Movie.self, from: $0)
        }
      } catch {
        return []
      }
    }
    return []
  }
  
  var savedMovies: [MovieViewModel] {
    return savedModels.map { MovieViewModel(movie: $0) }
  }
}
