//
//  Movie.swift
//  MovieDB
//
//  Created by Chris Mitchelmore on 27/07/2017.
//  Copyright © 2017 Marks and Spencer. All rights reserved.
//

import Foundation

struct Movie: Codable {
  enum CodingKeys: String, CodingKey {
    case id
    case posterPath = "poster_path"
    case overview
    case releaseDate = "release_date"
    case title
    case popularity
    case collection = "belongs_to_collection"
  }
  
  let id: Int?
  let posterPath: String?
  let overview: String?
  let releaseDate: Date?
  let title: String?
  let popularity: Double?
  let collection: MovieCollectionSummary?
}

struct MovieCollectionSummary: Codable {
  let id: Int?
}

extension Movie: Equatable {
  static func ==(lhs: Movie, rhs: Movie) -> Bool {
    guard let rid = rhs.id, let lid = lhs.id else { return false }
    return rid == lid
  }
}

extension Movie {
  init(summary: MovieSummary) {
    id = summary.id
    posterPath = summary.posterPath
    title = summary.title
    popularity = summary.popularity
    overview = nil
    releaseDate = nil
    collection = nil
  }
}
