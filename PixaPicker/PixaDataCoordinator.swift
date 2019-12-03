//
//  PixaDataCoordinator.swift
//  PixaPicker
//
//  Created by Thomas Caraway on 11/22/19.
//  Copyright © 2019 Thomas Caraway. All rights reserved.
//

import Foundation

class PixaDataCoordinator {
    
    var delegate: PixaDataCoordinatorDelegate?
    var cellImageURLs = [URL]()
    var currentPageNumber = 1
    let maxImagesPerPage = 20
    
    func getNextPage(withCurrentSearchText: String){
        currentPageNumber += 1
        (PixaBayAPIService.loadPixaBayRequest(withURL: URLExtensions.pixabaySearchURL(with: withCurrentSearchText, with: self.currentPageNumber), completion: {
            self.delegate?.didGetNextPage(self, urls: $0)
        }))
    }
    
    func updateSearchResults(with currentSearchText: String){
        currentPageNumber = 1
        (PixaBayAPIService.loadPixaBayRequest(withURL: URLExtensions.pixabaySearchURL(with: currentSearchText, with: currentPageNumber), completion: {
            self.cellImageURLs = $0 
            //self.imageCollectionView.reloadData()
        }))
        self.delegate?.didUpdateSearchResults()
    }
    
    //TODO: getCellImage() func. Logic is in viewcontroller, move here
}
