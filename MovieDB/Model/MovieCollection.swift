//
//  MovieCollection.swift
//  MovieDB
//
//  Created by Chris Mitchelmore on 27/07/2017.
//  Copyright © 2017 Marks and Spencer. All rights reserved.
//

import Foundation

struct MovieCollection: Codable {
  let name: String?
  let parts: [MovieSummary]
}
