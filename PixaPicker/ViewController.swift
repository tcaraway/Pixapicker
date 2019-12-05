//
//  ViewController.swift
//  PixaPicker
//
//  Created by Thomas Caraway on 8/24/19.
//  Copyright © 2019 Thomas Caraway. All rights reserved.
//

//

import UIKit
import SDWebImage

class ViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PixaDataCoordinatorDelegate{
    

    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    let reuseID = "cell"
    var dataCoordinator:PixaDataCoordinator?
    
    
    //UICollectionViewDelegateFlowLayout protocol functions
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width - 20, height: 240)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
    //PixaDataCoordinatorDelegate protocol functions
    func didGetNextPage(_ sender: PixaDataCoordinator, urls: [URL]) {
        dataCoordinator?.appendURLImageArray(with: urls)
        self.imageCollectionView.reloadData()
    }
    
    func didUpdateSearchResults(){
        self.imageCollectionView.reloadData()
    }
    
    
    //UICollectionView protocol functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataCoordinator?.imageCount ?? 0
    }
    
    //where populating of images into cells occurs
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath as IndexPath) as! PixaCollectionViewCell
        
        //Loads a bunch of images for "infinite" scrolling.
        //TODO: This is probably not the correct logic. Revisit later        
        guard let cellImageURLCount = dataCoordinator?.imageCount else { return imageCell }
        if indexPath.row < cellImageURLCount {
            guard let imageURL : URL = dataCoordinator?.getImageURL(for: indexPath.row) else { return imageCell }
            imageCell.cellImage.sd_setImage(with: imageURL, placeholderImage: nil)
        }
        return imageCell
    }
    
    
    //UICollectionViewDelegate protocol functions
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = imageCollectionView.cellForItem(at: indexPath) as? PixaCollectionViewCell
        guard let image = selectedCell?.cellImage.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //Saving tapped photos to album
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer){
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "The image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        self.dataCoordinator?.currentSearchText = searchText
        dataCoordinator?.reloadSearch()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataCoordinator = PixaDataCoordinator()
        setupSearchController()
        self.dataCoordinator?.delegate = self
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
    
    func shouldGetNextPage(withIndexRow: Int) -> Bool{
        guard let currentPageNumber = dataCoordinator?.currentPageNumber else { return false }
        guard let maxImagesPerPage = dataCoordinator?.maxImagesPerPage else { return false }
        let indexRowToAddRemainder = withIndexRow % ((currentPageNumber * maxImagesPerPage) - 2)
        let conditionOne = (indexRowToAddRemainder == 0)
        
        guard let currentImageAmount = dataCoordinator?.imageCount else { return false }
        let conditionTwo = (currentImageAmount <= (currentPageNumber * maxImagesPerPage))
        
        return (conditionOne && conditionTwo)
    }
    }
