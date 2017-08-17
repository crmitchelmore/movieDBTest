//
//  MovieSummary.swift
//  MovieDB
//
//  Created by Chris Mitchelmore on 27/07/2017.
//  Copyright © 2017 Marks and Spencer. All rights reserved.
//

import Foundation

struct MovieSummary: Codable {
  enum CodingKeys: String, CodingKey {
    case id
    case posterPath = "poster_path"
    case title
    case popularity
  }
  let id: Int?
  let posterPath: String?
  let title: String?
  let popularity: Double?
}

extension MovieSummary: Equatable {
  static func ==(lhs: MovieSummary, rhs: MovieSummary) -> Bool {
    return lhs.id == rhs.id
  }
}
