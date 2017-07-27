//
//  MasterViewController.swift
//  MovieDB
//
//  Created by Chris Mitchelmore on 27/07/2017.
//  Copyright © 2017 Marks and Spencer. All rights reserved.
//

import UIKit

class NowPlayingViewController: UICollectionViewController {
  
  let noTitleString = "No Title"
  let refreshControl = UIRefreshControl()
  
  var nowPlayingViewModel: NowPlayingViewModel!
  
  var detailViewController: MovieDetailsViewController? = nil
  var objects = [Any]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView?.register(MovieSummaryCell.self, forCellWithReuseIdentifier: "MovieSummaryCell")
    collectionView?.allowsMultipleSelection = false
    
    collectionView!.alwaysBounceVertical = true
    refreshControl.tintColor = .green
    refreshControl.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
    collectionView?.addSubview(refreshControl)
    
    let organizeButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(showFilterAndSortOptions(_:)))
    navigationItem.rightBarButtonItem = organizeButton
    if let split = splitViewController {
        let controllers = split.viewControllers
        detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? MovieDetailsViewController
    }
  }

  func refreshMoviews() {
    nowPlayingViewModel.refreshMovies { [weak self] result in
      switch result {
      case .success(let nowPlayingViewModel):
        self?.nowPlayingViewModel = nowPlayingViewModel
        self?.collectionView?.reloadData()
        self?.refreshControl.endRefreshing()
      case .error(error)
        self?.showError(error)
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
    super.viewWillAppear(animated)
  }
  
  // MARK: - Segues

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showMovie", let movie = sender as? MovieViewModel, let movieDetailsVC = segue.destination as? MovieDetailsViewController {
      movieDetailsVC.showMovie(movie)
    }
  }
  
  func showMovie(_ movie: MovieViewModel) {
    if let detailViewController = detailViewController {
      detailViewController.showMovie(movie)
    } else {
      performSegue(withIdentifier: "showMovie", sender: movie)
    }
  }
  
  func showError(_ error: Error) {
    print(error.localizedDescription)
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return nowPlayingViewModel.moviesToDisplay.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let movieSummaryCell = collectionView.dequeueReusableCell(withIdentifier: "MovieSummaryCell", for: indexPath) as! MovieSummaryCell
    let movieSummary = nowPlayingViewModel.moviesToDisplay[indexPath.row]
    movieSummaryCell.configureWith(title: movieSummary.title ?? noTitleString, imageUrl: movieSummary.posterPath)
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let movieSummary = nowPlayingViewModel.moviesToDisplay[indexPath.row]
    nowPlayingViewModel.movie(for: movieSummary) { [weak self] result in
      switch result {
      case .success(let movie):
        self?.showMovie(movie)
      case .error(error)
        self?.showError(error)
      }
    }
  }

}

