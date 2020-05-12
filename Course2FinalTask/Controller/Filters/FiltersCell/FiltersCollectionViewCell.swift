//
//  FiltersCollectionViewCell.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 11.05.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit

class FiltersCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var thumbnailPhoto: UIImageView!
    @IBOutlet var filterNameLabel: UILabel!

    
    func setFilter(_ name: String, for photo: UIImage) {
        thumbnailPhoto.image = photo.resizedImage()
        filterNameLabel.text = name
    }

}
