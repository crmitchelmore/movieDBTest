//
//  FilterOptionsViewController.swift
//  MovieDB
//
//  Created by Chris Mitchelmore on 27/07/2017.
//  Copyright © 2017 Marks and Spencer. All rights reserved.
//

import UIKit

protocol FilterOptionsDelegate: class {
  func updateFilterOptions(_ options: NowPlayingFilterOptions?, sortBy: NowPlayingSortByOptions?)
  func closeFilterOptions()
}

class FilterOptionsViewController: UIViewController, UITextFieldDelegate {
  
  weak var delegate: FilterOptionsDelegate?
  
  private var filterOptions: NowPlayingFilterOptions?
  private var sortOptions: NowPlayingSortByOptions?
  
  @IBOutlet var sortBy: UISegmentedControl?
  @IBOutlet var filterBy: UISegmentedControl?
  @IBOutlet var filterValue: UITextField?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Filter Options"
  }
  
  @IBAction func sortByTapped(sender: UISegmentedControl) {
    sortOptions = sender.selectedSegmentIndex == 0 ? .popularityAscending : .popularityDescending
  }
  
  @IBAction func filterByTapped(sender: UISegmentedControl) {
    updateFilterOptions()
  }
  
  
  @IBAction func doneTapped(sender: Any) {
    delegate?.updateFilterOptions(filterOptions, sortBy: sortOptions)
    delegate?.closeFilterOptions()
  }
  
  @IBAction func clearTapped(sender: Any) {
    delegate?.updateFilterOptions(nil, sortBy: nil)
    delegate?.closeFilterOptions()
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    return Double(string) != nil
  }
  
  func updateFilterOptions() {
    if let valueString = filterValue?.text, let value = Double(valueString) {
      filterOptions = NowPlayingFilterOptions.popularity(op: filterBy?.selectedSegmentIndex == 0 ? .greaterThan : .lessThan, value: value)
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    updateFilterOptions()
    return true
  }
}

