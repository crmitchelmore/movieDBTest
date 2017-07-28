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
  let persistanceService = MoviePersistanceServiceImplementation.shared
  
  @IBOutlet weak var relatedMoviesCollectionView: UICollectionView!
  var movieViewModel: MovieViewModel? {
    didSet {
      if view.window != nil {
        refreshView()
      }
    }
  }
  
  @IBOutlet weak var ipadFavouritesButton: UIButton?
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
    movieViewModel?.loadRelatedMovies { [weak self] result in
      switch result {
      case .success(let relatedMovies):
        self?.relatedMoviesCollectionView.isHidden = relatedMovies.count == 0
        self?.relatedMoviesCollectionView.collectionViewLayout.invalidateLayout()
        self?.relatedMoviesCollectionView.reloadData()
      case .error(let error):
        self?.showError(error)
      }
    }
  }
  
  func refreshView() {
    guard let movieViewModel = movieViewModel else { return }
    title = movieViewModel.title
    titleLabel?.text = movieViewModel.title
    popularity?.text = movieViewModel.popularity
    overview?.text = movieViewModel.overview
    cancelImageLoad = imageView?.loadImageFromPath(movieViewModel.imageUrl)
    configureFavouriteButton()
  }
  
  func configureFavouriteButton(){
    let isSaved = persistanceService.savedMovies.contains { $0.movie.id == self.movieViewModel?.movie.id }
    if isSaved {
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeFromWatchList))
      ipadFavouritesButton?.setTitle("Remove from Favourites", for: .normal)
      ipadFavouritesButton?.addTarget(self, action: #selector(removeFromWatchList), for: .touchUpInside)
    } else {
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToWatchList))
      ipadFavouritesButton?.setTitle("Add to Favourites", for: .normal)
      ipadFavouritesButton?.addTarget(self, action: #selector(addToWatchList), for: .touchUpInside)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never
    relatedMoviesCollectionView.register(UINib(nibName: "MovieSummaryCell", bundle: nil), forCellWithReuseIdentifier: "MovieSummaryCell")
    refreshView()
    flowLayout.estimatedItemSize = CGSize(width: 140, height: 200)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    refreshView()
  }
  
  var flowLayout: UICollectionViewFlowLayout {
    return relatedMoviesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
  }
  
  @objc func removeFromWatchList() {
    persistanceService.removeMovie(movieViewModel!)
    configureFavouriteButton()
  }
  
  @objc func addToWatchList() {
    persistanceService.addMovie(movieViewModel!)
    configureFavouriteButton()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    cancelImageLoad?.cancel()
  }
}

extension MovieDetailsViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return movieViewModel?.relatedMovies.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let movieSummaryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieSummaryCell", for: indexPath) as! MovieSummaryCell
    let movieSummary = movieViewModel!.relatedMovies[indexPath.row]
    movieSummaryCell.configureWith(title: movieSummary.title, imageUrl: movieSummary.imageUrl, size: CGSize(width: 0, height: collectionView.frame.size.height - 40))
    return movieSummaryCell
  }
}

extension MovieDetailsViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let movieSummary = movieViewModel!.relatedMovies[indexPath.row]
    onShowMovie(movieSummary)
  }
}
