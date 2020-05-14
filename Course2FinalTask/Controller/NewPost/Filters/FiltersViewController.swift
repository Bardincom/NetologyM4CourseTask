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
    
    let filters = Filters().filterArray
    
    let operationQueue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFiltersViewController()
    }
}

extension FiltersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? FiltersCollectionViewCell else {
            assertionFailure()
            return
        }
        
        guard let thumbnailPhotos = selectPhoto else { return }
        let filterName = filters[indexPath.row]
        
        cell.setFilter(filterName, for: thumbnailPhotos)
    }
    
    /// отступ между ячейками
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { 16 }
}

extension FiltersViewController: UICollectionViewDataSource  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeue(cell: FiltersCollectionViewCell.self, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ActivityIndicator.start()
        let selectFilter = filters[indexPath.row]
        
        let applyFilter = ImageFilterOperation(inputImage: selectPhoto, filter: selectFilter)
        
        applyFilter.completionBlock = { [weak self] in
            guard let self = self else { return }
            
            OperationQueue.main.addOperation {
                self.bigImage.image = applyFilter.outputImage
                ActivityIndicator.stop()
            }
        }
        
        operationQueue.addOperation(applyFilter)
    }
}


private extension FiltersViewController {
    
    func setupFiltersViewController() {
        navigationItem.rightBarButtonItem = .init(title: "Next", style: .plain, target: self, action: #selector(pressNextButton(_:)))
        bigImage.image = selectPhoto
        title = NamesItemTitle.filters
    }
    
    
    
    @objc func pressNextButton(_ sender: UITapGestureRecognizer) {
        let descriptionScreenViewController = DescriptionScreenViewController()
        guard let publishedPhoto = bigImage.image else { return  }
        descriptionScreenViewController.newPublishedPhoto = publishedPhoto
        self.navigationController?.pushViewController(descriptionScreenViewController, animated: true)
    }
}
