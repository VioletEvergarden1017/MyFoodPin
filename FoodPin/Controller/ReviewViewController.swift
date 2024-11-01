//
//  ReviewViewController.swift
//  FoodPin
//
//  Created by zhiye on 2024/10/30.
//

import UIKit

class ReviewViewController: UIViewController {

    @IBOutlet var backgroundImageView: UIImageView!
    // Ouelet collection
    @IBOutlet var rateButtons: [UIButton]!
    @IBOutlet var exitButton: UIButton!
    
    var restaurant = Restaurant()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backgroundImageView.image = restaurant.image
        
        // Applying the blur effect 启用背景模糊效果
        let blurEffect = UIBlurEffect(style: .dark) // 可选效果.dark .light .extralight
        let blurEffectView = UIVisualEffectView(effect: blurEffect) // 建立一个带有模糊效果的UIVisualEffectView物件
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        // slide-in animataion
        let moveRightTransform = CGAffineTransform.init(translationX: 600, y: 0) // 声明一个将画面移至右侧的常数,水平方向滑入
        let scaleUpTransform = CGAffineTransform.init(scaleX: 5.0, y: 5.0)
        // combined animation
        let moveScaleTransform = scaleUpTransform.concatenating(moveRightTransform)
        // exit animation
        let moveTopTransfrom = CGAffineTransform.init(translationX: 0, y: -100) // 将exit按钮移动至y方向上饭200像素
        
        // hide all the buttons 隐藏按钮
        for rateButton in rateButtons {
            rateButton.transform = moveScaleTransform // apply transformation to buttons
            rateButton.alpha = 0 // 设定透明度为0隐藏按钮
        }
        // solution:为exit按钮添加动画
        exitButton.alpha = 0
        exitButton.transform = moveTopTransfrom
    }
    
    // MARK: - 建立动画效果
    override func viewWillAppear(_ animated: Bool) {
        // 为每一个按钮设定不同的delay值，构建更好的淡入动画效果
//        UIView.animate(withDuration: 0.4, delay: 0.1, options: [], animations: {
//            self.rateButtons[0].alpha = 1.0
//        }, completion: nil)
//        UIView.animate(withDuration: 0.4, delay: 0.15, options: [], animations: {
//            self.rateButtons[1].alpha = 1.0
//        }, completion: nil)
//        UIView.animate(withDuration: 0.4, delay: 0.2, options: [], animations: {
//            self.rateButtons[2].alpha = 1.0
//        }, completion: nil)
//        UIView.animate(withDuration: 0.4, delay: 0.25, options: [], animations: {
//            self.rateButtons[3].alpha = 1.0
//        }, completion: nil)
//        UIView.animate(withDuration: 0.4, delay: 0.3, options: [], animations: {
//            self.rateButtons[4].alpha = 1.0
//        }, completion: nil)
        
        
        // solution:为exit按钮加上动画
        UIView.animate(withDuration: 2,animations: {
            self.exitButton.alpha = 1.0
            self.exitButton.transform = .identity
        }, completion: nil)
        
        // 恒等变形 identity transform
        for k in 0 ... 4 {
            UIView.animate(withDuration: 0.4, delay: 0.05 + Double(k) * 0.05, animations: {
                self.rateButtons[k].alpha = 1.0
                self.rateButtons[k].transform = .identity
            }, completion: nil)
        }
        
//        UIView.animate(withDuration: 0.8, delay: 0.1, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.3,options: [], animations: {// 给动画加上弹簧效果，加上了damping(控制弹簧的阻尼值)与initialSpringVelocity参数
//            self.rateButtons[0].alpha = 1.0
//            self.rateButtons[0].transform = .identity
//        }, completion: nil)
//        UIView.animate(withDuration: 0.4, delay: 0.15, options: [], animations: {
//            self.rateButtons[1].alpha = 1.0
//            self.rateButtons[1].transform = .identity
//        }, completion: nil)
//        UIView.animate(withDuration: 0.4, delay: 0.2, options: [], animations: {
//            self.rateButtons[2].alpha = 1.0
//            self.rateButtons[2].transform = .identity
//        }, completion: nil)
//        UIView.animate(withDuration: 0.4, delay: 0.25, options: [], animations: {
//            self.rateButtons[3].alpha = 1.0
//            self.rateButtons[3].transform = .identity
//        }, completion: nil)
//        UIView.animate(withDuration: 0.4, delay: 0.3, options: [], animations: {
//            self.rateButtons[4].alpha = 1.0
//            self.rateButtons[4].transform = .identity
//        }, completion: nil)
    }
    
}
