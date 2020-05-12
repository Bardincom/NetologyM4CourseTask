//
//  NewPostViewController.swift
//  Course2FinalTask
//
//  Created by Aleksey Bardin on 26.04.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit
import DataProvider

final class NewPostViewController: UIViewController, NibInit {
    
    @IBOutlet private var newPostViewController: UICollectionView! {
        willSet{
            newValue.register(nibCell: ProfileCollectionViewCell.self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NamesItemTitle.newPost
    }
    
}


extension NewPostViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoNewPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeue(cell: ProfileCollectionViewCell.self, for: indexPath)
    }
    
    
}


extension NewPostViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ProfileCollectionViewCell else {
            assertionFailure()
            return
        }
        
        let photo = photoNewPosts[indexPath.row]
        /// установка изображений
        cell.imageView(newPhoto: photo)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = newPostViewController.bounds.width / 3
        return CGSize(width: size, height: size)
    }
    
    /// убираю отступ между ячейками
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectPhoto = photoNewPosts[indexPath.row]

        let filtersViewController = FiltersViewController()
        
        filtersViewController.selectPhoto = selectPhoto
        self.navigationController?.pushViewController(filtersViewController, animated: true)
        newPostViewController.deselectItem(at: indexPath, animated: true)
    }
    
}



