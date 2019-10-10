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
    
    @IBOutlet weak var picsCollection: UICollectionView!
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        (PixaBayAPIService.loadPixaBayRequest(withURL: URLExtensions.pixabaySearchURL(withtext: searchText), completion: {
            self.setCellImages(withURLs: $0)
        }))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        // Do any additional setup after loading the view.
    }

    private func setupSearchController(){
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Image Search"
        navigationItem.searchController = searchController
        searchController.searchBar.sizeToFit()
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setCellImages(withURLs: [URL]){
        var urlArrayIndex = 0
        for cell in picsCollection.visibleCells{
            if urlArrayIndex == 20{
                urlArrayIndex = 0;
            }
            let imageView = UIImageView()
            imageView.sd_setImage(with: withURLs[urlArrayIndex], placeholderImage: nil)
            cell.addSubview(imageView)
            urlArrayIndex = urlArrayIndex + 1
            print("Test")
        }
    }
    
    

    
}

