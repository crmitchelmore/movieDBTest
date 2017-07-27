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
    case overview
    case releaseDate = "release_date"
    case title
    case popularity
  }
  let id: Int?
  let posterPath: String?
  let overview: String?
  let releaseDate: Date?
  let title: String?
  let popularity: Double?
}
