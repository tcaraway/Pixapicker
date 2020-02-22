//
//  PixaFavoritesCoordinator.swift
//  PixaPicker
//
//  Created by Thomas Caraway on 2/6/20.
//  Copyright © 2020 Thomas Caraway. All rights reserved.
//

import Foundation
import CoreData

class PixaFavoritesCoordinator {
    
    var delegate: PixaFavoritesCoordinatorDelegate?
    var cellImageManagedObjects = [NSManagedObject]()
    var cellImageURLs = [String]()
    
    func convertManagedObjectsToStrings(){
        self.cellImageURLs = [String]()
        for obj in cellImageManagedObjects{
            let temp = obj.value(forKey: "urlstring")
            cellImageURLs.append(temp as! String)
        }
        
    }
    

}
