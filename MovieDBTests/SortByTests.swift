//
//  SortByTests.swift
//  MovieDBTests
//
//  Created by Chris Mitchelmore on 28/07/2017.
//  Copyright © 2017 Marks and Spencer. All rights reserved.
//


import XCTest
@testable import MovieDB

class MovieDBTests: XCTestCase {
  
  
  func test_sortMovies_ascending_sortsMovies() {
    let sut = NowPlayingSortByOptions.popularityAscending
    let movieSummaries = [
      MovieSummary(id: nil, posterPath: nil, title: nil, popularity: 1),
      MovieSummary(id: nil, posterPath: nil, title: nil, popularity: 3),
      MovieSummary(id: nil, posterPath: nil, title: nil, popularity: 2)
    ]
    let expected = [
      MovieSummary(id: nil, posterPath: nil, title: nil, popularity: 1),
      MovieSummary(id: nil, posterPath: nil, title: nil, popularity: 2),
      MovieSummary(id: nil, posterPath: nil, title: nil, popularity: 3)
    ]
    XCTAssertEqual((sut.sortMovies(movieSummaries), expected)
  }
  
  func test_sortMovies_descending_sortsMovies() {
    let sut = NowPlayingSortByOptions.popularityAscending
    let movieSummaries = [
      MovieSummary(id: nil, posterPath: nil, title: nil, popularity: 1),
      MovieSummary(id: nil, posterPath: nil, title: nil, popularity: 3),
      MovieSummary(id: nil, posterPath: nil, title: nil, popularity: 2)
    ]
    let expected = [
      MovieSummary(id: nil, posterPath: nil, title: nil, popularity: 3),
      MovieSummary(id: nil, posterPath: nil, title: nil, popularity: 2),
      MovieSummary(id: nil, posterPath: nil, title: nil, popularity: 1)
    ]
    XCTAssertEqual((sut.sortMovies(movieSummaries), expected)
  }
}

