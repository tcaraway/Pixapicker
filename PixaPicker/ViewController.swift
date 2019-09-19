//
//  ViewController.swift
//  PixaPicker
//
//  Created by Thomas Caraway on 8/24/19.
//  Copyright © 2019 Thomas Caraway. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    let apiKey = "key=13683470-874d69ddffa828cbb82551e32" //API key for my Pixabay account
    @IBOutlet weak var picsCollection: UICollectionView!
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        let searchTextWithoutSpaces = searchText.replacingOccurrences(of: " ", with: "+")
        let urlWithAPI = "https://pixabay.com/api/?" + apiKey
        let urlWithSeachText = urlWithAPI + "&q=" + searchTextWithoutSpaces
        let finalURL = urlWithSeachText + "&image_type=photo"
        print(finalURL) //FOR TESTING ONLY
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Image Search"
        navigationItem.searchController = searchController
        searchController.searchBar.sizeToFit()
        navigationItem.hidesSearchBarWhenScrolling = false
        
        
        // Do any additional setup after loading the view.
    }


}

