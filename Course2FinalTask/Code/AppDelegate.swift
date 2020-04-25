//
//  AppDelegate.swift
//  Course2FinalTask
//
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        assembly()
        
        return true
    }
}

private extension AppDelegate {
    
    func assembly(){
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let feedViewController = FeedViewController.initFromNib()
        feedViewController.tabBarItem.image = imageFeedViewController
        let feedNavigationController = UINavigationController(rootViewController: feedViewController)
        
        let profileViewController = ProfileViewController.initFromNib()
        profileViewController.tabBarItem.title = ControllerSet.profileViewController
        profileViewController.tabBarItem.image = imageProfileViewController
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        
        let newPostViewController = NewPostViewController.initFromNib()
        newPostViewController.tabBarController?.title = ControllerSet.newPostViewController
        newPostViewController.tabBarItem.image = imageNewPostViewController
        let newNavigationController = UINavigationController(rootViewController: newPostViewController)
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = viewBackgroundColor
        tabBarController.setViewControllers([feedNavigationController, newNavigationController, profileNavigationController], animated: false)
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}


