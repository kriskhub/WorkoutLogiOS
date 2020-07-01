//
//  TabBarController.swift
//  WorkoutLog
//
//  Created by Kristian Kullmann on 01.04.20.
//  Copyright © 2020 Kristian Kullmann. All rights reserved.
//

import Foundation
import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate, UINavigationControllerDelegate {
    // UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 0 {
            NotificationCenter.default.post(name: .today, object: nil)
        }
    }

    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected view controller")
    }
}
