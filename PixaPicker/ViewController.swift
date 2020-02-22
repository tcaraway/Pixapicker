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
import CoreData

class ViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PixaDataCoordinatorDelegate, PixaSaveButtonDelegate, PixaFavoriteButtonDelegate{
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    let reuseID = "cell"
    let dataCoordinator = PixaDataCoordinator()
    
    
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
    func didGetNextPage(_ sender: PixaDataCoordinator) {
        self.imageCollectionView.reloadData()
    }
    
    func didUpdateSearchResults(){
        self.imageCollectionView.reloadData()
        self.imageCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true) //scroll back to top
    }
    
    //PixaSaveButtonDelegate protocol functions
    func saveButtonTapped(_ sender: PixaCollectionViewCell) {
        guard let image = sender.cellImage.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //PixaFavoriteButtonDelegate protocol functions
    func favoriteButtonTapped(_ sender: PixaCollectionViewCell) {
        saveURL(withString: sender.urlString!)
        imageCollectionView.reloadData()

    }
    
    //UICollectionView protocol functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataCoordinator.imageCount
    }
    
    //where populating of images into cells occurs
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath as IndexPath) as! PixaCollectionViewCell
        
        imageCell.delegate = self
        imageCell.delegate2 = self
        
        //Loads a bunch of images for "infinite" scrolling.
        if indexPath.row < dataCoordinator.imageCount {
            imageCell.favoriteButton.isEnabled = true
            let imageURL : URL = dataCoordinator.getImageURL(for: indexPath.row)
            imageCell.cellImage.sd_setImage(with: imageURL, placeholderImage: nil)
            imageCell.urlString = imageURL.absoluteString
        }
        return imageCell
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
        self.dataCoordinator.currentSearchText = searchText
        dataCoordinator.reloadSearch()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        self.dataCoordinator.delegate = self
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
    
    private func saveURL(withString: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "ImageURL", in: managedContext)!
        
        let newURL = NSManagedObject(entity: entity, insertInto: managedContext)
        
        newURL.setValue(withString, forKeyPath: "urlstring")
        
        do{
            try managedContext.save()
        } catch let error as NSError{
            print("Could not save. \(error)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    }
