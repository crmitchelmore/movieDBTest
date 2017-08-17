//
//  MasterViewController.swift
//  MovieDB
//
//  Created by Chris Mitchelmore on 27/07/2017.
//  Copyright © 2017 Marks and Spencer. All rights reserved.
//

import UIKit

class NowPlayingViewController: UICollectionViewController {
  
  let refreshControl = UIRefreshControl()
  
  var nowPlayingViewModel: NowPlayingViewModel?
  
  var detailViewController: MovieDetailsViewController? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Now Playing"

    collectionView?.register(UINib(nibName: "MovieSummaryCell", bundle: nil), forCellWithReuseIdentifier: "MovieSummaryCell")
    
    collectionView?.allowsMultipleSelection = false
    
    collectionView!.alwaysBounceVertical = true
    refreshControl.tintColor = .green
    refreshControl.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
    collectionView?.addSubview(refreshControl)
    collectionView?.contentInset = UIEdgeInsetsMake(0, 10, 0, 10)
    if let split = splitViewController {
        let controllers = split.viewControllers
        detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? MovieDetailsViewController
    }
    
    flowLayout.estimatedItemSize = CGSize(width: cellWidth(), height: cellWidth() * 2)
    loadMovies()
  }
  
  var flowLayout: UICollectionViewFlowLayout {
    return collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
  }
  
  func loadMovies() {
    navigationController?.showLoadingIndicator()
    MovieDBServiceImplementation.shared.getMovies { result in
      self.navigationController?.showLoadingIndicator(false)
      switch result {
      case .success(let nowPlaying):
        self.nowPlayingViewModel = NowPlayingViewModel(nowPlaying: nowPlaying)
        self.showFirstMovie()
        self.collectionView?.reloadData()
      case .error(let error):
        print(error)
      }
    }
  }
  
  func showFirstMovie() {
    guard UI_USER_INTERFACE_IDIOM() == .pad else { return }
    if let movies = nowPlayingViewModel?.moviesToDisplay, movies.count > 0 {
      detailViewController?.showMovie(MovieViewModel(movie: Movie(summary: movies[0].movieSummary)), onShowMovie: pushMovieSummary) //Use summary whilst we load the full movie
      showMovieSummary(movies[0])
    }
  }
  
  @objc func refreshMovies() {
    navigationController?.showLoadingIndicator()
    nowPlayingViewModel?.refreshMovies { [weak self] result in
      self?.navigationController?.showLoadingIndicator(false)
      switch result {
      case .success(let nowPlayingViewModel):
        self?.nowPlayingViewModel = nowPlayingViewModel
        self?.collectionView?.reloadData()
        self?.refreshControl.endRefreshing()
      case .error(let error):
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
    if (segue.identifier == "showMovie" || segue.identifier == "pushMovie"), let movie = sender as? MovieViewModel, let movieDetailsVC = segue.destination as? MovieDetailsViewController {
      movieDetailsVC.showMovie(movie, onShowMovie: pushMovieSummary)
    } else if segue.identifier == "showFilterOptions", let nav = segue.destination as? UINavigationController, let filterVc = nav.topViewController as? FilterOptionsViewController {
      filterVc.delegate = self
      filterVc.setInitialOptions(nowPlayingViewModel?.currentFilter, sortOptions: nowPlayingViewModel?.currentSortBy)
    }
  }
  
  func pushMovieSummary(_ movieSummary: MovieSummaryViewModel) {
    showMovieSummary(movieSummary, pushVC: true)
  }
  
  func showMovieSummary(_ movieSummary: MovieSummaryViewModel, pushVC: Bool = false) {
    navigationController?.showLoadingIndicator()
    nowPlayingViewModel?.movie(for: movieSummary) { [weak self] result in
      self?.navigationController?.showLoadingIndicator(false)
      switch result {
      case .success(let movie):
        self?.performSegue(withIdentifier: pushVC && UI_USER_INTERFACE_IDIOM() != .pad ? "pushMovie" : "showMovie", sender: movie)
      case .error(let error):
        self?.showError(error)
      }
    }
  }
  
  func showError(_ error: Error) {
    print(error.localizedDescription)
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return nowPlayingViewModel?.moviesToDisplay.count ?? 0
  }
  
  func cellWidth() -> CGFloat {
    let cols: CGFloat = 2
    let availableWidth = collectionView!.contentSize.width
    let availableWidthForCells = availableWidth - (cols - 1) * flowLayout.minimumInteritemSpacing
    return availableWidthForCells / cols
  }
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let movieSummaryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieSummaryCell", for: indexPath) as! MovieSummaryCell
    let movieSummary = nowPlayingViewModel!.moviesToDisplay[indexPath.row]
    
    movieSummaryCell.configureWith(title: movieSummary.title, imageUrl: movieSummary.imageUrl, size: CGSize(width: cellWidth(), height: 0))
    return movieSummaryCell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let movieSummary = nowPlayingViewModel!.moviesToDisplay[indexPath.row]
    showMovieSummary(movieSummary)
  }

}

extension NowPlayingViewController: FilterOptionsDelegate {
  func updateFilterOptions(_ options: NowPlayingFilterOptions?, sortBy: NowPlayingSortByOptions?) {
    nowPlayingViewModel?.filterMoviesBy(options)
    nowPlayingViewModel?.sortMoviesBy(sortBy)
    collectionView?.reloadData()
  }
  
  func closeFilterOptions() {
    dismiss(animated: true, completion: nil)
  }
}

