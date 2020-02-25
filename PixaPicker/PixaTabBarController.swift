//
//  PixaTabBarController.swift
//  PixaPicker
//
//  Created by Thomas Caraway on 2/25/20.
//  Copyright © 2020 Thomas Caraway. All rights reserved.
//

import Foundation
import UIKit

class PixaTabBarController: UITabBarController{
    var searchViewController = ViewController()
    var favoritesViewController = PixaFavoritesViewController()
    
    override func viewDidLoad() {
        let navController = self.viewControllers![0] as! UINavigationController
        searchViewController = navController.topViewController as! ViewController
        favoritesViewController = self.viewControllers![1] as! PixaFavoritesViewController
        print(searchViewController.teststring) //FOR TESTING
        print(favoritesViewController.teststring) //FOR TESTING
    }
}
