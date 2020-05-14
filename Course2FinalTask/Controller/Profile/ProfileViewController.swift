//
//  ProfileViewController.swift
//  Course2FinalTask
//
//  Created by Aleksey Bardin on 24.02.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit
import DataProvider

final class ProfileViewController: UIViewController, NibInit {
    
    var userProfile: User? {
        didSet {
            setupProfileViewController()
        }
    }
    
    var currentUser: User?
    
    private var postsProfile: [Post]?
    
    @IBOutlet weak private var profileCollectionView: UICollectionView! {
        willSet {
            newValue.register(nibCell: ProfileCollectionViewCell.self)
            newValue.register(nibSupplementaryView: ProfileHeaderCollectionReusableView.self, kind: UICollectionView.elementKindSectionHeader)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = viewBackgroundColor
        userDataProviders.currentUser(queue: queue) { [weak self] currentUser in
            guard let currentUser = currentUser else {
                self?.displayAlert()
                return }
            self?.currentUser = currentUser
            
        }
        
        setupProfileViewController()
    }
}

//MARK: DataSourse
extension ProfileViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let postsProfile = postsProfile else { return [Post]().count }
        return postsProfile.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeue(cell: ProfileCollectionViewCell.self, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        return collectionView.dequeue(supplementaryView: ProfileHeaderCollectionReusableView.self,
                                      kind: kind, for: indexPath)
    }
    
    /// задаю размеры Header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 86)
    }
}

//MARK: Delegate FlowLayout
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ProfileCollectionViewCell else {
            assertionFailure()
            return
        }
        
        guard let postsProfile = postsProfile else { return }
        let post = postsProfile[indexPath.row]
        /// установка изображений
        cell.setImageCell(post: post)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        guard let view = view as? ProfileHeaderCollectionReusableView else {
            assertionFailure()
            return  }
        
        guard let userProfile = userProfile else { return }
        /// установка Хедера
        view.setHeader(user: userProfile)
        view.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = profileCollectionView.bounds.width / 3
        return CGSize(width: size, height: size)
    }
    
}

//MARK: setViewController
extension ProfileViewController {
    
    func setupProfileViewController() {
        
        ActivityIndicator.start()
        if userProfile == nil {
            userDataProviders.currentUser(queue: queue) { [weak self] user in
                guard let user = user else {
                    self?.displayAlert()
                    return }
                self?.userProfile = user
            }
            
            DispatchQueue.main.async {
                self.view.backgroundColor = viewBackgroundColor
                self.title = self.userProfile?.username
                self.profileCollectionView.reloadData()
            }
        }
        
        guard let userProfile = userProfile?.id else { return }
        
        postsDataProviders.findPosts(by: userProfile, queue: queue) { [weak self] post in
            guard let post = post else {
                self?.displayAlert()
                return }
            self?.postsProfile = post
            
            DispatchQueue.main.async {
                
                self?.view.backgroundColor = viewBackgroundColor
                self?.title = self?.userProfile?.username
                self?.tabBarItem.title = ControllerSet.profileViewController
                self?.profileCollectionView.reloadData()
                ActivityIndicator.stop()
            }
        }
    }
}

//MARK: ProfileHeaderDelegate
extension ProfileViewController: ProfileHeaderDelegate {
    /// Открывает список подписчиков
    func openFollowersList() {
        
        ActivityIndicator.start()
        
        let userListViewController = UserListViewController()
        
        guard let userID = userProfile?.id else { return }
        userDataProviders.usersFollowingUser(with: userID, queue: queue) { users in
            guard let users = users else {
                self.displayAlert()
                return }
            userListViewController.usersList = users
            
            DispatchQueue.main.async {
                userListViewController.navigationItemTitle = NamesItemTitle.following
                self.navigationController?.pushViewController(userListViewController, animated: true)
                ActivityIndicator.stop()
            }
        }
    }
    
    /// Открывает список подписок
    func openFollowingList() {
        ActivityIndicator.start()
        
        let userListViewController = UserListViewController()
        
        guard let userID = userProfile?.id else { return }
        
        userDataProviders.usersFollowedByUser(with: userID, queue: queue, handler: { users in
            guard let users = users else {
                self.displayAlert()
                return }
            
            userListViewController.usersList = users
            
            DispatchQueue.main.async {
                userListViewController.navigationItemTitle = NamesItemTitle.followers
                self.navigationController?.pushViewController(userListViewController, animated: true)
                ActivityIndicator.stop()
            }
        })        
    }
    
    // TODO: убрать интикатор загрузки при подписке или отписке
    func followUnfollowUser() {
        
        guard let userProfile = userProfile else { return }
        print(userProfile.id)
        if userProfile.currentUserFollowsThisUser {
            userDataProviders.unfollow(userProfile.id, queue: queue) { user in
                guard let user = user else {
                    self.displayAlert()
                    return }
                self.userProfile = user
                
                DispatchQueue.main.async {
                    self.currentUser?.followsCount += 1
                    self.profileCollectionView.reloadData()
                }
            }
            
        } else {
            userDataProviders.follow(userProfile.id, queue: queue) { user in
                guard let user = user else {
                    self.displayAlert()
                    return }
                self.userProfile = user
                
                DispatchQueue.main.async {
                    self.currentUser?.followsCount += 1
                    self.profileCollectionView.reloadData()
                }
            }
        }
    }
}
