//
//  DataProvider Properties.swift
//  Course2FinalTask
//
//  Created by Aleksey Bardin on 11.03.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import DataProvider

public let queue = DispatchQueue.global(qos: .userInitiated)
//
//public let userHandler: ((User?) -> Void) = { user in
//    guard let user = user else { return }
//}
//
//public let postsHandler: (([Post]?) -> Void) = { posts in
//    guard let posts = posts else { return }
//
//}


//func userNew(user: User?) {
//    
//}

/// Поставщик публикаций
public let postsDataProviders = DataProviders.shared.postsDataProvider

/// Поставщик пользователей
public let userDataProviders = DataProviders.shared.usersDataProvider

/// Поставщик фотографий для новых публикаций
public let photoProvider = DataProviders.shared.photoProvider

/// Фото для новых публикаций
public var photoNewPosts = photoProvider.photos()



/// Текущий пользователь
//public let currentUser: () = users.currentUser(queue: queue, handler: userHandler)

/// Массив постов. Массив пустой если нет постов или текущий пользователь ни на кого не подписан.
//public var postsFeed: () = posts.feed(queue: queue, handler: postsHandler)

/// Развертывание опционала для публикаций
//func selectPosts(posts: [Post]?) -> [Post] {
//    guard let posts = posts else { return [Post]() }
//    return posts
//}


/// Развертывание опционала для пользователя
//func selectUser(user: User?) -> () {
//    guard let user = user else { return currentUser }
//    var selectUser: User
//    selectUser = user
//}

func selectUsers(users: [User]?) -> [User] {
    guard let users = users else {
        return [User]()
    }
    return users
}
