//
//  WalkthroughViewController.swift
//  FoodPin
//
//  Created by zhiye on 2024/11/3.
//

import UIKit

class WalkthroughViewController: UIViewController {

    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var nextButton: UIButton! {
        didSet {// 给uibutton设置圆角
            nextButton.layer.cornerRadius = 25.0
            nextButton.layer.masksToBounds = true
        }
    }
    @IBOutlet var skipButton: UIButton!
    var walkthroughPageViewController: WalkthroughPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? WalkthroughPageViewController {
            walkthroughPageViewController = pageViewController
        }
        
        walkthroughPageViewController?.walkthroughDelegate = self
    }
    
    @IBAction func skipButtonTapped(sender: UIButton) {
        // 修改UserDefaults信息
        UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonTapped(sender: UIButton) {
        
        if let index = walkthroughPageViewController?.currentIndex {
            
            switch index {
            case 0...1: // 对于前两页，呼叫forwardPage()方法来显示下一个导览界面
                walkthroughPageViewController?.forwardPage()
            case 2:
                // 当用户按下「GET STARTED」按钮，修改存储在UserDefaults当中的状态信息，表面使用者看完了导览画面
                UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
                dismiss(animated: true, completion: nil)
            default: break
            }
            
            updateUI()
        }
    }
    
    func updateUI() {
        
        if let index = walkthroughPageViewController?.currentIndex {
            switch index {
            case 0...1:
                nextButton.setTitle(String(localized: "NEXT"), for: .normal)
                skipButton.isHidden = false
            case 2:
                nextButton.setTitle(String(localized: "GET SRARTED"), for: .normal)
                skipButton.isHidden = true
            default: break
            }
            
            pageControl.currentPage = index
        }
    }
}

// MARK: - WalkthroughPageViewControllerDelegate 协定
extension WalkthroughViewController: WalkthroughPageViewControllerDelegate {
    
    func didUpdatePageIndex(currentIndx: Int) {
        updateUI()
    }
}
