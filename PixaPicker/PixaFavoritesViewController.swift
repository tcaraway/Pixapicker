//
//  PixaFavoritesViewController.swift
//  PixaPicker
//
//  Created by Thomas Caraway on 2/3/20.
//  Copyright © 2020 Thomas Caraway. All rights reserved.
//

import Foundation
import SDWebImage
import UIKit
import CoreData

class PixaFavoritesViewController: UIViewController, PixaSaveButtonDelegate, PixaFavoriteButtonDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PixaFavoritesCoordinatorDelegate{
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    let reuseID = "cell"
    let favoritesCoordinator = PixaFavoritesCoordinator()
    let teststring = "FAVES"
    
    //UICollectionViewDataSource protocol functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritesCoordinator.cellImageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath as IndexPath) as! PixaCollectionViewCell
        
        imageCell.delegate = self
        imageCell.delegate2 = self
        
        let imageURL = URL(string: favoritesCoordinator.cellImageURLs[indexPath.row])
        imageCell.cellImage.sd_setImage(with: imageURL, placeholderImage: nil)
        imageCell.urlString = favoritesCoordinator.cellImageURLs[indexPath.row]
        
        return imageCell
    }
    
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
    
    //PixaSaveButtonDelegate protocol functions
    func saveButtonTapped(_ sender: PixaCollectionViewCell) {
        guard let image = sender.cellImage.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func favoriteButtonTapped(_ sender: PixaCollectionViewCell) {
        favoritesCoordinator.cellImageURLs.remove(at: imageCollectionView.indexPath(for: sender)!.row)
        favoritesCoordinator.removeURL(urlstring: sender.urlString!)
        self.imageCollectionView.reloadData()
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
    
    override func viewDidAppear(_ animated: Bool) {
        favoritesCoordinator.loadURLs()
        self.imageCollectionView.reloadData()
        print(favoritesCoordinator.cellImageURLs.count)
    }
    
    override func viewDidLoad() {
        favoritesCoordinator.loadURLs()
        self.imageCollectionView.reloadData()
        print(favoritesCoordinator.cellImageURLs.count)
    }
    
    
    
}
