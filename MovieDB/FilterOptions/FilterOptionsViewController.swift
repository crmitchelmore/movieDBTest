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
  
  @IBOutlet var sortBySegmentedControl: UISegmentedControl?
  @IBOutlet var filterBySegmentedControl: UISegmentedControl?
  @IBOutlet var filterValue: UITextField?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Filter Options"
    onVDL?()
  }
  
  private var onVDL: (() -> Void)?
  func setInitialOptions(_ filterOptions: NowPlayingFilterOptions?, sortOptions: NowPlayingSortByOptions?) {
    onVDL = {
      self.sortOptions = sortOptions
      self.filterOptions = filterOptions
      
      if let filterOptions = filterOptions {
        switch filterOptions {
        case .popularity(let op, let value):
          self.filterValue?.text = "\(value)"
          switch op {
          case .greaterThan:
            self.filterBySegmentedControl?.selectedSegmentIndex = 0
          case .lessThan:
            self.filterBySegmentedControl?.selectedSegmentIndex = 1
          }
        }
      } else {
        self.filterBySegmentedControl?.selectedSegmentIndex = UISegmentedControlNoSegment
      }
      
      if let sortOptions = sortOptions {
        switch sortOptions {
        case .popularityAscending:
          self.sortBySegmentedControl?.selectedSegmentIndex = 0
        case .popularityDescending:
          self.sortBySegmentedControl?.selectedSegmentIndex = 1
        }
      } else {
        self.sortBySegmentedControl?.selectedSegmentIndex = UISegmentedControlNoSegment
      }
    }
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
      filterOptions = NowPlayingFilterOptions.popularity(op: filterBySegmentedControl?.selectedSegmentIndex == 0 ? .greaterThan : .lessThan, value: value)
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    updateFilterOptions()
    return true
  }
}

