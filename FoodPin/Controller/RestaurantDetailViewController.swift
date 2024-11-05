//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by Simon Ng on 1/12/2023.
//

import UIKit

class RestaurantDetailViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: RestaurantDetailHeaderView!
    @IBOutlet var favoriteBarButton: UIBarButtonItem!
    
    var restaurant: Restaurant = Restaurant()
    var dataStore: RestaurantDataStore?

    //MARK: - 细节视图控制器生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        // solution to modify the title of backbutton
        navigationItem.backButtonTitle = "" // 设置返回的标题返回细节界面
      
        // Configure header view
        headerView.nameLabel.text = restaurant.name
        headerView.typeLabel.text = restaurant.type
        headerView.headerImageView.image = restaurant.image
        
        // Configure Favorite icon
        configureFavoriteIcon()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never // 使得表格视图上移至画面的边缘
    }

    // MARK: - 每当显示视图时，viewWillAppear方式被呼出
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false // 在细节视图当中关闭「滑动隐藏导航栏目」功能
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Navigation 传入所选餐厅至地图控制器当中
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // 根据segue的标识符来传入restaurant实体
        switch segue.identifier {
        case "showMap":    // 情况为「显示地图」
            let destinationController = segue.destination as! MapViewController
            destinationController.restaurant = restaurant
            destinationController.hidesBottomBarWhenPushed = true // 隐藏标签列
            
        case "showReview": // 情况为「显示评价」
            let destinationController = segue.destination as! ReviewViewController
            destinationController.restaurant = restaurant
            destinationController.hidesBottomBarWhenPushed = true
            
        default: break
        }
    }
    

    // 声明一个方法与评价按钮对应，并添加一些动画效果
    @IBAction func rateRestaurant(segue: UIStoryboardSegue) {
        
        guard let identifier = segue.identifier else {
            return
        }
        
        dismiss(animated: true, completion: {
            if let rating = Restaurant.Rating(rawValue: identifier) {
                self.restaurant.rating = rating
                self.headerView.ratingImageView.image = UIImage(named: rating.image)
            }
            // add a scale animation
            let scaleTransform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            self.headerView.ratingImageView.transform = scaleTransform
            self.headerView.ratingImageView.alpha = 0 // 设定初始状态
            // apply the animation
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.7, options: [], animations: {
                self.headerView.ratingImageView.transform = .identity
                self.headerView.ratingImageView.alpha = 1
            }, completion: nil)
        })

    }
    
    @IBAction func close(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
}



// MARK: - Extensions

extension RestaurantDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailTextCell.self), for: indexPath) as! RestaurantDetailTextCell
            
            cell.descriptionLabel.text = restaurant.summary
            cell.selectionStyle = .none
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailTwoColumnCell.self), for: indexPath) as! RestaurantDetailTwoColumnCell
            
            cell.column1TitleLabel.text = "Address"
            cell.column1TextLabel.text = restaurant.location
            cell.column2TitleLabel.text = "Phone"
            cell.column2TextLabel.text = restaurant.phone
            cell.selectionStyle = .none
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailMapCell.self), for: indexPath) as! RestaurantDetailMapCell
            cell.configure(location: restaurant.location)
            cell.selectionStyle = .none
            
            return cell
            
        default:
            fatalError("Failed to instantiate the table view cell for detail view controller")
            
        }
    }
    
    // MARK: - Favorite Function
    
    @IBAction func saveFavorite() {
        
        restaurant.isFavorite.toggle()
                
        configureFavoriteIcon()// 见下

        dataStore?.updateSnapshot(animatingChange: false)
        
    }
    
    func configureFavoriteIcon() {
        let heartImage = restaurant.isFavorite ? "heart.fill" : "heart"
        let heartIconConfiguration = UIImage.SymbolConfiguration(pointSize: 25, weight: .semibold)
        favoriteBarButton.image = UIImage(systemName: heartImage, withConfiguration: heartIconConfiguration)
        favoriteBarButton.tintColor = restaurant.isFavorite ? .systemYellow : .white
    }
}

