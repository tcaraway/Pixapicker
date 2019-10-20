//
//  ViewController.swift
//  PixaPicker
//
//  Created by Thomas Caraway on 8/24/19.
//  Copyright © 2019 Thomas Caraway. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    let cellCount = 20
    let reuseID = "cell"
    var cellImageURLs = [URL]()
    
    //UICollectionView protocol functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath as IndexPath) as! PixaCollectionViewCell
        
//        if cellImageURLs.count > 0 {
//            imageCell.cellImage.sd_setImage(with: cellImageURLs[indexPath.item], placeholderImage: nil)
//            //LEFT OFF HERE
//            //cellImageURLs is not being populated w/ URLs before this gets called. count always = 0
//        }
        return imageCell
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        (PixaBayAPIService.loadPixaBayRequest(withURL: URLExtensions.pixabaySearchURL(withtext: searchText), completion: {
            self.cellImageURLs = $0
        }))
        var imageIndex = 0
        for cell in imageCollectionView.visibleCells as! [PixaCollectionViewCell]{
            if self.cellImageURLs.count > 0{
                if imageIndex == self.cellImageURLs.count{
                    imageIndex = 0
                }
                cell.cellImage.sd_setImage(with: self.cellImageURLs[imageIndex], placeholderImage: nil)
                imageIndex = imageIndex + 1
            }
        }
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
//        var urlArrayIndex = 0
//        for cell in picsCollection.visibleCells{
//            if urlArrayIndex == 20{
//                urlArrayIndex = 0;
//            }
//            let imageView = UIImageView()
//            imageView.sd_setImage(with: withURLs[urlArrayIndex], placeholderImage: nil)
//            cell.addSubview(imageView)
//            urlArrayIndex = urlArrayIndex + 1
//            print("Test")
        }
    }
    
    

    


