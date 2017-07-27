//
//  DetailViewController.swift
//  MovieDB
//
//  Created by Chris Mitchelmore on 27/07/2017.
//  Copyright © 2017 Marks and Spencer. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
  
  var cancelImageLoad: Cancelable?
  var onShowMovie: ((MovieSummaryViewModel) -> Void)!
  
  @IBOutlet weak var relatedMoviesCollectionView: UICollectionView!
  var movieViewModel: MovieViewModel! {
    didSet {
      titleLabel?.text = movieViewModel.title
      popularity?.text = movieViewModel.popularity
      overview?.text = movieViewModel.overview
      cancelImageLoad = imageView?.loadImageFromUrl(movieViewModel.imageUrl)
    }
  }
  
  @IBOutlet weak var imageView: UIImageView?
  @IBOutlet weak var titleLabel: UILabel?
  @IBOutlet weak var popularity: UILabel?
  @IBOutlet weak var overview: UILabel?
  
  func showError(_ error: Error) {
    print(error.localizedDescription)
  }
  
  func showMovie(_ movie: MovieViewModel, onShowMovie: @escaping (MovieSummaryViewModel) -> Void) {
    movieViewModel = movie
    self.onShowMovie = onShowMovie
    movieViewModel.loadRelatedMovies { [weak self] result in
      switch result {
      case .success(let relatedMovies):
        self?.relatedMoviesCollectionView.isHidden = relatedMovies.count == 0
        self?.relatedMoviesCollectionView.reloadData()
      case .error(let error):
        self?.showError(error)
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    cancelImageLoad?.cancel()
  }
}

extension MovieDetailsViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return movieViewModel.relatedMovies.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let movieSummaryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieSummaryCell", for: indexPath) as! MovieSummaryCell
    let movieSummary = movieViewModel.relatedMovies[indexPath.row]
    movieSummaryCell.configureWith(title: movieSummary.title, imageUrl: movieSummary.imageUrl)
    return movieSummaryCell
  }
}

extension MovieDetailsViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let movieSummary = movieViewModel.relatedMovies[indexPath.row]
    onShowMovie(movieSummary)
  }
}
