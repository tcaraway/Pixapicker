//
//  PixaFavoritesCoordinator.swift
//  PixaPicker
//
//  Created by Thomas Caraway on 2/6/20.
//  Copyright © 2020 Thomas Caraway. All rights reserved.
//

import Foundation
import CoreData
import UIKit

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
    
    func loadURLs() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ImageURL")
        
        do {
            cellImageManagedObjects = try managedContext.fetch(fetchRequest)
            convertManagedObjectsToStrings()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func removeURL(urlstring: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ImageURL")
        
        if let result = try? managedContext.fetch(fetchRequest) {
            for object in result {
                if((object.value(forKey: "urlstring") as! String) == urlstring){
                    managedContext.delete(object)
                }
            }
        }
        do{
            try managedContext.save()
        } catch let error as NSError{
            print("Could not save. \(error)")
        }
    }
    
    func saveURL(withString: String){
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
    
    func isFavorited(urlstring: String) -> Bool{
        return cellImageURLs.contains(urlstring)
    }
    
}
