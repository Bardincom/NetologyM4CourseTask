//
//  FiltersViewController.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 11.05.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {
    
    @IBOutlet var bigImage: UIImageView!
    
    @IBOutlet private var filterViewController: UICollectionView! {
           willSet{
               newValue.register(nibCell: ProfileCollectionViewCell.self)
           }
       }
    
    public var selectPhoto: UIImage?
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        bigImage.image = selectPhoto
        title = NamesItemTitle.filters
    }
    
    
}

extension FiltersViewController: UICollectionViewDelegateFlowLayout {
    
}

extension FiltersViewController: UICollectionViewDataSource  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print(thumbnailPhotos.count)
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeue(cell: ProfileCollectionViewCell.self, for: indexPath)
 
    }
    
    
}
