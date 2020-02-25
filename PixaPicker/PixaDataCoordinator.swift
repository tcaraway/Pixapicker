//
//  PixaDataCoordinator.swift
//  PixaPicker
//
//  Created by Thomas Caraway on 11/22/19.
//  Copyright © 2019 Thomas Caraway. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class PixaDataCoordinator {
    
    var delegate: PixaDataCoordinatorDelegate?
    private var cellImageURLs = [URL]()
    var imageCount: Int { return cellImageURLs.count}
    private var currentPageNumber = 1
    var currentSearchText = ""
    let maxImagesPerPage = 20
    var isGettingNextPage = false
    var exhausted = false

    
    private func getNextPage(){
        guard isGettingNextPage == false && exhausted == false else { return }
        isGettingNextPage = true
        let nextPage = currentPageNumber + 1
        (PixaBayAPIService.loadPixaBayRequest(withURL: URLExtensions.pixabaySearchURL(with: currentSearchText, with: nextPage), completion: {
            self.currentPageNumber = nextPage
            self.appendURLImageArray(with: $0)
            self.delegate?.didGetNextPage(self)
            self.isGettingNextPage = false
        }))
    }
    
    func shouldGetNextPage(with indexRow: Int) -> Bool{
        return indexRow == (imageCount - 2) && imageCount % 20 == 0
    }
    
    func reloadSearch(){
        currentPageNumber = 1
        (PixaBayAPIService.loadPixaBayRequest(withURL: URLExtensions.pixabaySearchURL(with: currentSearchText, with: currentPageNumber), completion: {
            self.cellImageURLs = $0
            self.delegate?.didUpdateSearchResults()
        }))
    }
    
    func getImageURL(for index: Int) -> URL{
        if (shouldGetNextPage(with: index)){
            getNextPage()
        }
        return cellImageURLs[index]
    }
    
    func appendURLImageArray(with urls: [URL]){
        cellImageURLs.append(contentsOf: urls)
    }
    
    
}
