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
    var isGettingNextPage = false

    
    private func getNextPage(){
        currentPageNumber += 1
        (PixaBayAPIService.loadPixaBayRequest(withURL: URLExtensions.pixabaySearchURL(with: currentSearchText, with: self.currentPageNumber), completion: {
            self.appendURLImageArray(with: $0)
            self.delegate?.didGetNextPage(self)
        }))
        
    }
    
    func shouldGetNextPage(withIndexRow: Int) -> Bool{
        let indexRowToAddRemainder = withIndexRow % ((currentPageNumber * maxImagesPerPage) - 2)
        let conditionOne = (indexRowToAddRemainder == 0)
        let conditionTwo = (imageCount <= (currentPageNumber * maxImagesPerPage))
        return (conditionOne && conditionTwo) && (!isGettingNextPage)
    }
    
    func reloadSearch(){
        currentPageNumber = 1
        (PixaBayAPIService.loadPixaBayRequest(withURL: URLExtensions.pixabaySearchURL(with: currentSearchText, with: currentPageNumber), completion: {
            self.cellImageURLs = $0
        }))
        self.delegate?.didUpdateSearchResults()
    }
    
    func getImageURL(for index: Int) -> URL{
        if (shouldGetNextPage(withIndexRow: index) ){
            getNextPage()
        }
        return cellImageURLs[index]
    }
    
    func appendURLImageArray(with urls: [URL]){
        cellImageURLs.append(contentsOf: urls)
    }

}
