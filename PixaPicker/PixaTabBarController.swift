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
    var tabBarCoordinator = PixaTabBarCoordinator()
    
    override func viewDidLoad() {
        let navController = self.viewControllers![0] as! UINavigationController
        tabBarCoordinator.searchViewController = (navController.topViewController as! ViewController)
        tabBarCoordinator.favesViewController = (self.viewControllers![1] as! PixaFavoritesViewController)
        print(tabBarCoordinator.favesViewController.testString)
        tabBarCoordinator.setDelegates()
    }
}
