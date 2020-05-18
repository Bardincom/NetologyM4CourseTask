//
//  UIViewController Properties.swift
//  Course2FinalTask
//
//  Created by Aleksey Bardin on 04.03.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit

let imageFeedViewController = #imageLiteral(resourceName: "feed")
let imageProfileViewController = #imageLiteral(resourceName: "profile")
let imageNewPostViewController = #imageLiteral(resourceName: "plus")

//@available(iOS 13.0, *)
//let config = UIImage.SymbolConfiguration(pointSize: 20.0, weight: .semibold, scale: .default)
//@available(iOS 13.0, *)
//let leftChevronImage = UIImage(systemName: "chevron.left", withConfiguration: config)

public enum ControllerSet {
    static let feedViewController = "Feed"
    static let profileViewController = "Profile"
    static let newPostViewController = "New"
}

public enum NamesItemTitle {
   static let likes = "Likes"
   static let followers = "Followers"
   static let following = "Following"
   static let newPost = "New Post"
   static let filters = "Filters"
}
