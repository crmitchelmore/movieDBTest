//
//  FilterTests.swift
//  MovieDBTests
//
//  Created by Chris Mitchelmore on 28/07/2017.
//  Copyright © 2017 Marks and Spencer. All rights reserved.
//

import XCTest
@testable import MovieDB

class FilterTests: XCTestCase {
 
  func test_includesMovie_greaterThan_10_withMoviePopularity100_isTrue() {
    let sut = NowPlayingFilterOptions.popularity(op: .greaterThan, value: 10)
    let movieSummary = MovieSummary(id: nil, posterPath: nil, title: nil, popularity: 100)
    XCTAssert(sut.includesMovie(movieSummary))
  }
  
  func test_includesMovie_LessThan_10_withMoviePopularity1_isTrue() {
    let sut = NowPlayingFilterOptions.popularity(op: .lessThan, value: 10)
    let movieSummary = MovieSummary(id: nil, posterPath: nil, title: nil, popularity: 1)
    XCTAssert(sut.includesMovie(movieSummary))
  }
  
  func test_includesMovie_greaterThan_10_withMoviePopularity1_isFalse() {
    let sut = NowPlayingFilterOptions.popularity(op: .greaterThan, value: 10)
    let movieSummary = MovieSummary(id: nil, posterPath: nil, title: nil, popularity: 1)
    XCTAssertFalse(sut.includesMovie(movieSummary))
  }
  
  func test_includesMovie_LessThan_10_withMoviePopularity100_isFalse() {
    let sut = NowPlayingFilterOptions.popularity(op: .lessThan, value: 10)
    let movieSummary = MovieSummary(id: nil, posterPath: nil, title: nil, popularity: 100)
    XCTAssertFalse(sut.includesMovie(movieSummary))
  }
  
}
