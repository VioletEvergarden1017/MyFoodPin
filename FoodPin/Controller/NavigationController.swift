//
//  NavigationController.swift
//  FoodPin
//
//  Created by zhiye on 2024/10/28.
//

import UIKit

class NavigationController: UINavigationController {

    // 变更状态列的样式
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
    
    
}
