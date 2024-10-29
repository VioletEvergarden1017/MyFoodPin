//
//  RestaurantTableViewCell.swift
//  FoodPin
//
//  Created by Simon Ng on 4/11/2023.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel! {
        didSet {
            nameLabel.numberOfLines = 0
        }
    }
    @IBOutlet var locationLabel: UILabel! {
        didSet {
            // 使得在超大字体下不隔断
            locationLabel.numberOfLines = 0
        }
    }
    @IBOutlet var typeLabel: UILabel! {
        didSet {
            typeLabel.numberOfLines = 0
        }
    }
    @IBOutlet var thumbnailImageView: UIImageView! {
        didSet {
            // 设置圆角
            thumbnailImageView.layer.cornerRadius = 20.0
            thumbnailImageView.clipsToBounds = true
        }
    }
    @IBOutlet var favoriteImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tintColor = .systemYellow
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
