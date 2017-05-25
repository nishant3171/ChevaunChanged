//
//  MainTabBarController.swift
//  ChevaunChanged
//
//  Created by Nishant Punia on 24/05/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .black
        view.backgroundColor = .blue
        
        if FIRAuth.auth()?.currentUser == nil {
            let loginController = LoginViewController()
            let navController = UINavigationController(rootViewController: loginController)
            DispatchQueue.main.async {
                self.present(navController, animated: true, completion: nil)
            }
        }
        
        setupViewControllers()
        
    }
    
    func setupViewControllers() {
        
        let chatNavController = templateTabBarController(selectedImage: #imageLiteral(resourceName: "ChatSelected"), unselectedImage: #imageLiteral(resourceName: "Chat"), viewController: RecentChatsViewController())
        let newProblemNavController = templateTabBarController(selectedImage: #imageLiteral(resourceName: "MainMedalSelected"), unselectedImage: #imageLiteral(resourceName: "Medal"), viewController: NewProblemViewController())
        let userNavController = templateTabBarController(selectedImage: #imageLiteral(resourceName: "ProfileSelected"), unselectedImage: #imageLiteral(resourceName: "Profile"), viewController: UserProfileViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        tabBar.tintColor = .black
        
        viewControllers = [chatNavController,
                           newProblemNavController,
                           userNavController]
        
        guard let items = tabBar.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    fileprivate func templateTabBarController(selectedImage: UIImage, unselectedImage: UIImage, viewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = viewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.selectedImage = selectedImage
        navController.tabBarItem.image = unselectedImage
        return navController
    }
}
