//
//  WalkthroughPageViewController.swift
//  FoodPin
//
//  Created by zhiye on 2024/11/3.
//

import UIKit

protocol WalkthroughPageViewControllerDelegate: AnyObject {
    func didUpdatePageIndex(currentIndx: Int)
}

class WalkthroughPageViewController: UIPageViewController {
    
    var pageHeadings = ["CREATE YOUR FOOD GUIDE", "SHOW YOU THE LOCATION", "DISCOVER GREAT RESTAURANT"]
    var pageImages = ["onboarding-1", "onboarding-2", "onboarding-3"]
    var pageSubHeadings = [
        "Pin your favorite restaurants and create your own food guide",
        "Search and locate your favorite restaurant on Maps",
        "Find restaurants shared by your friends and other foodies"
    ]
    var currentIndex = 0

    weak var walkthroughDelegate: WalkthroughPageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 将数据源设定为自己
        dataSource = self
        
        // 建立第一个导览界面
        if let startingViewController = contentViewController(at: 0) {
            
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
        
        // 指定UIPageViewControllerDelegate协定的委派
        delegate = self
    }
    
    func forwardPage() {// 该方法被呼叫时，会自动建立下一个内容视图控制器
        currentIndex += 1 // 索引+1
        if let nextViewController = contentViewController(at: currentIndex) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
            // 呼叫内建方法setView Controllers，并导航至下一个视图控制器
        }
    }
}

// MARK: - UIPageViewControllerDataSource 协定
extension WalkthroughPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! WalkthroughContentViewController).index
        index -= 1
        
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index += 1
        
        return contentViewController(at: index)
    }
    
    // contentViewController(at:) 辅助方法的实现
    func contentViewController(at index:Int) -> WalkthroughContentViewController? {
        if index < 0 || index >= pageHeadings.count {
            return nil
        }
        
        // 建立新的视图控制器并传入合相关资料
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let pageContentViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughContentViewController") as? WalkthroughContentViewController {
            
            pageContentViewController.imageFile = pageImages[index]
            pageContentViewController.heading = pageHeadings[index]
            pageContentViewController.subHeading = pageSubHeadings[index]
            pageContentViewController.index = index
            
            return pageContentViewController
        }
        return nil
    }
}

// MARK: - UIPageViewControllerDelegate 协议
extension WalkthroughPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            if let contentViewController = pageViewController.viewControllers?.first as? WalkthroughContentViewController {
                
                // 找到目前页面的索引值
                currentIndex = contentViewController.index
                // 呼叫didUpdatePageIndex来通知这个委派
                walkthroughDelegate?.didUpdatePageIndex(currentIndx: contentViewController.index)
            }
        }
    }
}

