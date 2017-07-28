//
//  NowPlayingViewModelTests.swift
//  MovieDBTests
//
//  Created by Chris Mitchelmore on 28/07/2017.
//  Copyright © 2017 Marks and Spencer. All rights reserved.
//

import XCTest
@testable import MovieDB

class MovieDBTests: XCTestCase {
  
  var sut: NowPlayingViewModel!
  override func setUp() {
    super.setUp()
    let movieSummaries = [
      MovieSummary(id: 1, posterPath: nil, title: nil, popularity: 10),
      MovieSummary(id: 2, posterPath: nil, title: nil, popularity: 30),
      MovieSummary(id: 3, posterPath: nil, title: nil, popularity: 20)
    ]
    let nowPlaying = NowPlaying(results: movieSummaries)
    sut = NowPlayingViewModel(nowPlaying: n)
  }
  
  func test_moviesToDisplay_returnsAllMovies() {
    XCTAssertEqual(sut.moviesToDisplay.count, 3)
  }
  
  func test_moviesToDisplay_respectsFilter_gt_15_popularity() {
    sut.filterMoviesBy(NowPlayingFilterOptions.popularity(op: .greaterThan, value: 15))
    XCTAssertEqual(sut.moviesToDisplay.count, 2)
  }
  
  func test_moviesToDisplay_respectsRemovingFilters() {
    sut.filterMoviesBy(NowPlayingFilterOptions.popularity(op: .greaterThan, value: 15))
    XCTAssertEqual(sut.moviesToDisplay.count, 2)
    sut.filterMoviesBy(nil)
    XCTAssertEqual(sut.moviesToDisplay.count, 3)
  }
  
  func test_moviesToDisplay_respectsSortBy_popularityAsc() {
    let expectation = [
      MovieSummary(id: 1, posterPath: nil, title: nil, popularity: 10),
      MovieSummary(id: 3, posterPath: nil, title: nil, popularity: 20),
      MovieSummary(id: 2, posterPath: nil, title: nil, popularity: 30)
    ]
    sut.sortMoviesBy(.popularityAscending)
    XCTAssertEqual(sut.moviesToDisplay, expectation)
  }
  
  func test_moviesToDisplay_respectsRemovingSortBy() {
    let expectation = [
      MovieSummary(id: 1, posterPath: nil, title: nil, popularity: 10),
      MovieSummary(id: 2, posterPath: nil, title: nil, popularity: 30),
      MovieSummary(id: 3, posterPath: nil, title: nil, popularity: 20)
    ]
    sut.sortMoviesBy(.popularityAscending)
    sut.sortMoviesBy(nil)
    XCTAssertEqual(sut.moviesToDisplay, expectation)
  }
  
  func test_moviesToDisplay_respectsCombinedFilterAndSortBy() {
    let expectation = [
      MovieSummary(id: 3, posterPath: nil, title: nil, popularity: 20),
      MovieSummary(id: 2, posterPath: nil, title: nil, popularity: 30)
    ]
    sut.sortMoviesBy(.popularityAscending)
    sut.filterMoviesBy(NowPlayingFilterOptions.popularity(op: .greaterThan, value: 15))
    XCTAssertEqual(sut.moviesToDisplay, expectation)
  }
}
