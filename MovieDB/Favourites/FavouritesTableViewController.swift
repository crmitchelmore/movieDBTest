//
//  FavouritesTableViewController.swift
//  MovieDB
//
//  Created by Chris Mitchelmore on 27/07/2017.
//  Copyright © 2017 Marks and Spencer. All rights reserved.
//

import UIKit

class FavouritesTableViewController: UITableViewController {
  
  let persistanceService = MoviePersistanceServiceImplementation.shared
  var favouriteMovies: [MovieViewModel] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.prefersLargeTitles = true
    title = "Favourite Movies"
    navigationItem.rightBarButtonItem = editButtonItem
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    favouriteMovies = persistanceService.savedMovies
    tableView.reloadData()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return favouriteMovies.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let favouritesCell = tableView.dequeueReusableCell(withIdentifier: "FavouritesCell", for: indexPath) as! FavouritesCell
    let movie = favouriteMovies[indexPath.row]
    favouritesCell.configureWith(title: movie.title, imageUrl: movie.imageUrl, popularity: movie.popularity)
    return favouritesCell
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      // Delete the row from the data source
      favouriteMovies.remove(at: indexPath.row)
      persistanceService.setSavedMovies(favouriteMovies)
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }
  
  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    let movingMovie = favouriteMovies.remove(at: sourceIndexPath.row)
    favouriteMovies[destinationIndexPath.row] = movingMovie
    persistanceService.setSavedMovies(favouriteMovies)
  }
}
