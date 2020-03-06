//
//  PixaTabBarCoordinator.swift
//  PixaPicker
//
//  Created by Thomas Caraway on 2/25/20.
//  Copyright © 2020 Thomas Caraway. All rights reserved.
//

import Foundation
import UIKit

class PixaTabBarCoordinator: PixaViewControllerDelegate{
    
    var searchViewController = ViewController()
    var favesViewController = PixaFavoritesViewController()
    
    func didUpdateFavorites() {
        favesViewController.imageCollectionView.reloadData()
        searchViewController.imageCollectionView.reloadData()
        print("didupdate 2") //GETTING CALLED NOW YAY
    }
    
    func setDelegates(){
        searchViewController.delegate = self
        favesViewController.delegate = self
    }
}
