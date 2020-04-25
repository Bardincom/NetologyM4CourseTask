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

enum ControllerSet {
    static let feedViewController = "Feed"
    static let profileViewController = "Profile"
    static let newPostViewController = "New"
}

enum NamesItemTitle {
   static let likes = "Likes"
   static let followers = "Followers"
   static let following = "Following"
//   static let newPost = "New Post"
}



