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
               newValue.register(nibCell: FiltersCollectionViewCell.self)
           }
       }
    
    public var selectPhoto: UIImage?
    let filters = Filters()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        bigImage.image = selectPhoto
        title = NamesItemTitle.filters
    }
    
    
}

extension FiltersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
         guard let cell = cell as? FiltersCollectionViewCell else {
                   assertionFailure()
                   return
               }
        
        guard let thumbnailPhotos = selectPhoto else { return }
        let filterName = filters.filterArray[indexPath.row]
        
        cell.setFilter(filterName, for: thumbnailPhotos)
    }
    
    /// отступ между ячейками
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { 16 }
}

extension FiltersViewController: UICollectionViewDataSource  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.filterArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeue(cell: FiltersCollectionViewCell.self, for: indexPath)
    }
}
