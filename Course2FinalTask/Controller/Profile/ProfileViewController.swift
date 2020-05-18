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

    var userProfile: User?
    var feedUserID: User.Identifier?
    private var currentUser: User?
    private var postsProfile: [Post]?

    @IBOutlet weak private var profileCollectionView: UICollectionView! {
        willSet {
            newValue.register(nibCell: ProfileCollectionViewCell.self)
            newValue.register(nibSupplementaryView: ProfileHeaderCollectionReusableView.self, kind: UICollectionView.elementKindSectionHeader)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.delegate = self
        tabBarController?.delegate = self

        view.backgroundColor = viewBackgroundColor

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let id = feedUserID {
            loadUserByProfile(id: id)
//            visibleBackButton()
        } else {
            loadCurrentUser()
        }
    }
}

// MARK: DataSourse
extension ProfileViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let postsProfile = postsProfile else { return [Post]().count }
        return postsProfile.count
    }

    /// установка изображений
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cell: ProfileCollectionViewCell.self, for: indexPath)

        guard let postsProfile = postsProfile else { return cell }
        let post = postsProfile[indexPath.row]

        cell.setImageCell(post: post)

        return cell
    }

    /// устновка Хедера
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        let view = collectionView.dequeue(supplementaryView: ProfileHeaderCollectionReusableView.self,
                                          kind: kind,
                                          for: indexPath)

        guard let userProfile = userProfile else { return view }

        view.setHeader(user: userProfile)
        view.delegate = self

        return view
    }

    /// задаю размеры Header
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 86)
    }
}

// MARK: Delegate FlowLayout
extension ProfileViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = profileCollectionView.bounds.width / 3
        return CGSize(width: size, height: size)
    }

}

// MARK: setViewController
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
                self.updateUI()
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
                self?.updateUI()
                ActivityIndicator.stop()
            }
        }
    }
}

// MARK: ProfileHeaderDelegate
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
                userListViewController.navigationItemTitle = NamesItemTitle.followers
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
                userListViewController.navigationItemTitle = NamesItemTitle.following
                self.navigationController?.pushViewController(userListViewController, animated: true)
                ActivityIndicator.stop()
            }
        })
    }

    func followUnfollowUser() {

        guard let userProfile = userProfile else { return }

        if userProfile.currentUserFollowsThisUser {
            userDataProviders.unfollow(userProfile.id, queue: queueInteractive) { user in
                guard let user = user else {
                    self.displayAlert()
                    return }
                self.userProfile = user

                DispatchQueue.main.async {
                    self.currentUser?.followsCount -= 1
                    self.profileCollectionView.reloadData()
                }
            }

        } else {
            userDataProviders.follow(userProfile.id, queue: queueInteractive) { user in
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

extension ProfileViewController {

    /// Возвращает на ленту с Профиля
    @objc
    func backToFeed(_ sender: UITapGestureRecognizer) {
        feedUserID = nil
        tabBarController?.selectedIndex = 0
    }

    /// Отображает кнопку назад при переходе с Ленты на профиль друга
    func visibleBackButton() {
//        if #available(iOS 13.0, *) {
//            navigationItem.leftBarButtonItem = .init(image: leftChevronImage, style: .plain, target: self, action: #selector(backToFeed(_:)))
//        } else {
//            navigationItem.leftBarButtonItem = nil
//        }
    }

    /// Загрузка профиля друга из ленты
    func loadUserByProfile(id: User.Identifier) {

        ActivityIndicator.start()
        feedUserID = id
        userDataProviders.user(with: id, queue: queue) { user in
            guard let user = user else {
                self.displayAlert()
                return
            }
            self.userProfile = user

            postsDataProviders.findPosts(by: user.id, queue: queue) { posts in
                guard let cPosts = posts else {
                    self.displayAlert()
                    return
                }
                self.postsProfile = cPosts
                self.updateUI()
            }
        }
    }

    /// Загрузка профиля текущего пользователя
    func loadCurrentUser() {

        ActivityIndicator.start()
        userDataProviders.currentUser(queue: queue) { user in
            guard let cUser = user else {
                self.displayAlert()
                return
            }
            self.userProfile = cUser

            postsDataProviders.findPosts(by: cUser.id, queue: queue) { posts in
                guard let cPosts = posts else {
                    self.displayAlert()
                    return
                }
                self.postsProfile = cPosts
                self.updateUI()
            }
        }
    }

    func updateUI() {
        DispatchQueue.main.async {
            ActivityIndicator.stop()
            self.view.backgroundColor = viewBackgroundColor
            self.title = self.userProfile?.username
            self.tabBarItem.title = ControllerSet.profileViewController
            self.profileCollectionView.reloadData()
        }
    }
}

extension ProfileViewController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController === ProfileViewController.self {
            updateUI()
        }
    }
}

extension ProfileViewController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController !== navigationController {
            feedUserID = nil
            navigationController?.popToRootViewController(animated: false)
        }
    }
}
