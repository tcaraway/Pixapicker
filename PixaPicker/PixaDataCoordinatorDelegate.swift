//
//  PixaDataCoordinatorDelegate.swift
//  PixaPicker
//
//  Created by Thomas Caraway on 11/22/19.
//  Copyright © 2019 Thomas Caraway. All rights reserved.
//

import Foundation

protocol PixaDataCoordinatorDelegate {
    
    func didGetNextPage(_ sender: PixaDataCoordinator, urls: [URL])
    func shouldGetNextPage(withIndexRow: Int) -> Bool
    func didUpdateSearchResults()
}
