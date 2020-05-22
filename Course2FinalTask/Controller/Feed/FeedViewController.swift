//
//  FeedViewController.swift
//  Course2FinalTask
//
//  Created by Aleksey Bardin on 24.02.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//

import UIKit
import DataProvider

final class FeedViewController: UIViewController {

    private var postsArray: [Post] = []
    private var post: Post?
    var newPost: ((Post) -> Void)?
    var alertAction: ((Bool) -> Void)?

    @IBOutlet weak private var feedCollectionView: UICollectionView! {
        willSet {
            newValue.register(nibCell: FeedCollectionViewCell.self)
        }
    }

    @IBOutlet weak private var collectionLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        postsDataProviders.feed(queue: queue) { posts in
            guard let posts = posts else {
                self.alertAction = { bool in
                    if bool {
                        self.displayAlert()
                    }
                }
                return }
            self.postsArray = posts
            DispatchQueue.main.async {
                if self.isViewLoaded {
                    self.feedCollectionView.reloadData()
                }
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // сюда попадает новая публикация и размещается вверху ленты
        newPost = { [weak self] post in
            self?.postsArray.insert(post, at: 0)
            // переходим в начало Ленты
            self?.feedCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            self?.feedCollectionView.reloadData()
        }

        alertAction?(isViewLoaded)

        title = ControllerSet.feedViewController
    }

}

// MARK: DataSource
extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeue(cell: FeedCollectionViewCell.self, for: indexPath)
        let post = postsArray[indexPath.row]

        cell.setupFeed(post: post)
        cell.delegate = self

        return cell
    }
}

// MARK: DelegateFlowLayout
extension FeedViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width

        let post = postsArray[indexPath.row]

        let estimatedFrame = NSString(string: post.description).boundingRect(with: CGSize(width: width - 8, height: width - 8), options: .usesLineFragmentOrigin, attributes: nil, context: nil)
        return CGSize(width: width, height: estimatedFrame.height + width + 130)
    }

    /// убираю отступ между ячейками
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: FeedCollectionViewProtocol
extension FeedViewController: FeedCollectionViewProtocol {

    /// открывает профиль пользователя
    func openUserProfile(cell: FeedCollectionViewCell) {

        guard let navigationController = tabBarController?.viewControllers?[2] as? UINavigationController else { return }
        guard let profileViewController = navigationController.viewControllers.first as? ProfileViewController else { return }

        guard let indexPath = feedCollectionView.indexPath(for: cell) else { return }

        let currentPost = postsArray[indexPath.row]

        profileViewController.feedUserID = currentPost.author

        DispatchQueue.main.async {
            self.tabBarController?.selectedViewController = navigationController
            navigationController.popToRootViewController(animated: true)
        }
    }

    /// ставит лайк на публикацию
    func likePost(cell: FeedCollectionViewCell) {

        guard let indexPath = feedCollectionView.indexPath(for: cell) else { return }

        let postID = postsArray[indexPath.row].id

        guard cell.likeButton.tintColor == lightGrayColor else {

            postsDataProviders.unlikePost(with: postID, queue: queue) { unlikePost in
                self.post = unlikePost
            }

            postsArray[indexPath.row].currentUserLikesThisPost = false
            postsArray[indexPath.row].likedByCount -= 1
            cell.tintColor = lightGrayColor
            self.feedCollectionView.reloadData()
            return
        }

        postsDataProviders.likePost(with: postID, queue: queue) { post in
            self.post = post
        }

        postsArray[indexPath.row].currentUserLikesThisPost = true
        postsArray[indexPath.row].likedByCount += 1
        cell.tintColor = defaultTintColor

        self.feedCollectionView.reloadData()
    }

    /// открывает список пользователей поставивших лайк
    func userList(cell: FeedCollectionViewCell) {
        ActivityIndicator.start()
        tabBarController?.selectedIndex = 2

        let userListViewController = UserListViewController()

        guard let indexPath = feedCollectionView.indexPath(for: cell) else { return }

        let currentPostID = postsArray[indexPath.row].id

        postsDataProviders.usersLikedPost(with: currentPostID, queue: queue) { usersArray in
            guard let usersArray = usersArray else {
                self.displayAlert()
                return }
            userListViewController.usersList = usersArray

            DispatchQueue.main.async {

                userListViewController.navigationItemTitle = NamesItemTitle.likes
                self.tabBarController?.selectedViewController = userListViewController
                self.navigationController?.pushViewController(userListViewController, animated: true)
                ActivityIndicator.stop()

            }
        }
    }
}
