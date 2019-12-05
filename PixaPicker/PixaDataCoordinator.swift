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
    private var cellImageURLs = [URL]()
    var imageCount: Int { return cellImageURLs.count}
    var currentPageNumber = 1
    var currentSearchText = ""
    let maxImagesPerPage = 20

    
    private func getNextPage(){
        currentPageNumber += 1
        (PixaBayAPIService.loadPixaBayRequest(withURL: URLExtensions.pixabaySearchURL(with: currentSearchText, with: self.currentPageNumber), completion: {
            self.delegate?.didGetNextPage(self, urls: $0)
        }))
    }
    
    func reloadSearch(){
        currentPageNumber = 1
        (PixaBayAPIService.loadPixaBayRequest(withURL: URLExtensions.pixabaySearchURL(with: currentSearchText, with: currentPageNumber), completion: {
            self.cellImageURLs = $0
        }))
        self.delegate?.didUpdateSearchResults()
    }
    
    func getImageURL(for index: Int) -> URL{
        if (delegate?.shouldGetNextPage(withIndexRow: index) ?? false){
            getNextPage()
        }
        return cellImageURLs[index]
    }
    
    func appendURLImageArray(with urls: [URL]){
        cellImageURLs.append(contentsOf: urls)
    }

}
