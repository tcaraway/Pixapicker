//
//  PixaCollectionViewCell.swift
//  PixaPicker
//
//  Created by Thomas Caraway on 10/18/19.
//  Copyright © 2019 Thomas Caraway. All rights reserved.
//

import Foundation
import UIKit

class PixaCollectionViewCell : UICollectionViewCell {
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    weak var delegate: PixaSaveButtonDelegate?
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        delegate?.saveButtonTapped(self)
    }
    
    
    
}


