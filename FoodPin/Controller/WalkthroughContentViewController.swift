//
//  WalkthroughContentViewController.swift
//  FoodPin
//
//  Created by zhiye on 2024/11/1.
//

import UIKit



class WalkthroughContentViewController: UIViewController {

    @IBOutlet var headingLabel: UILabel! {
        didSet {
            headingLabel.numberOfLines = 0
        }
    }
    @IBOutlet var subheadingLabel: UILabel! {
        didSet {
            subheadingLabel.numberOfLines = 0
        }
    }
    @IBOutlet var conteneImageView: UIImageView!
    
    var index = 0 // index用于存储当前页面的索引值
    var heading = ""
    var subHeading = ""
    var imageFile = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // initialze labels and image
        headingLabel.text = heading
        subheadingLabel.text = subHeading
        conteneImageView.image = UIImage(named: imageFile)
    }
    
}
