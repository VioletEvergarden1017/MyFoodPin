//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by Simon Ng on 4/11/2023.
//

import UIKit
import SwiftData

// 声明一个协议，swiftData的UIkit版本不会自动跟踪数据更新，所以需要添加如下协议明确指示RestaurantTableViewController检索更新的餐厅记录
protocol RestaurantDataStore {
    func fetchRestaurantData()
    func updateSnapshot(animatingChange: Bool)
}

class RestaurantTableViewController: UITableViewController, RestaurantDataStore{
    
    // 声明一个回退动作给new Restaurant Segue
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet var emptyRestaurantView: UIView!
    
    var restaurants:[Restaurant] = []
    var container: ModelContainer? // 声明一个模型容器
    var searchController: UISearchController! // 声明一个搜索列实例
    
    lazy var dataSource = configureDataSource()
    
    // MARK: - View controller life cycle 视图控制器的生命周期
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 建立容器
        container = try? ModelContainer(for: Restaurant.self)
        
        navigationItem.backButtonTitle = "" // 修改返回按钮的标题为空
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.hidesBarsOnSwipe = true // 启用以滑动方式隐藏导航栏
        
        // 给视图加上搜索列
        searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        
        // 个性化主页面，使背景透明化并更改标题的颜色
        if let appearance = navigationController?.navigationBar.standardAppearance {
            
            appearance.configureWithTransparentBackground() // 设置导航列为透明背景且无阴影
            // 使用个性化大标题
            if let customFont = UIFont(name: "Nunito-Bold", size: 45.0) {
                // 个性化标题的颜色
                //let color = UIColor(named: "NavigationBarTitle")
                appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!, .font: customFont]
            }
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        tableView.cellLayoutMarginsFollowReadableWidth = true
        // 准备空视图
        tableView.backgroundView = emptyRestaurantView
        tableView.backgroundView?.isHidden = restaurants.count == 0 ? false : true
        //tableView.backgroundView?.isHidden = true
        
        fetchRestaurantData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - UITableView Diffable Data Source
    
    func configureDataSource() -> RestaurantDiffableDataSource {
        
        let cellIdentifier = "datacell"
        
        let dataSource = RestaurantDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, restaurant in
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell
                
                cell.nameLabel.text = restaurant.name
                cell.locationLabel.text = restaurant.location
                cell.typeLabel.text = restaurant.type
                cell.thumbnailImageView.image = restaurant.image
                cell.favoriteImageView.isHidden = restaurant.isFavorite ? false : true
                
                return cell
            }
        )
        
        return dataSource
    }
    
    // MARK: - UITableViewDelegate Protocol
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Get the selected restaurant 获取一个选定的餐厅
        guard let restaurant = self.dataSource.itemIdentifier(for: indexPath) else {
            return UISwipeActionsConfiguration()
        }
        
        // Delete action 「删除」动作
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            
            var snapshot = self.dataSource.snapshot()
            snapshot.deleteItems([restaurant])
            self.dataSource.apply(snapshot, animatingDifferences: true)
            // 由于变更了restaurant的参数类型，补充下面一行代码是的从数据库当中删除restaurant
            self.container?.mainContext.delete(restaurant)
            // Call completion handler to dismiss the action button
            completionHandler(true)
        }
        
        // Share action 「分享」动作
        let shareAction = UIContextualAction(style: .normal, title: "Share") { (action, sourceView, completionHandler) in
            let defaultText = "Just checking in at " + restaurant.name
            
            let activityController: UIActivityViewController
            activityController = UIActivityViewController(activityItems: [defaultText, restaurant.image], applicationActivities: nil)
//            if let imageToShare = UIImage(named: restaurant.image) {
//                activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
//            } else  {
//                activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
//            }
            
            if let popoverController = activityController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            
            self.present(activityController, animated: true, completion: nil)
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = UIColor.systemRed
        deleteAction.image = UIImage(systemName: "trash")

        shareAction.backgroundColor = UIColor.systemOrange
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        
        // Configure both actions as swipe action 将「分享、删除」动作加入左划动作列表
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
            
        return swipeConfiguration
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Mark as favorite action 添加「喜爱」动作
        let favoriteAction = UIContextualAction(style: .destructive, title: "") { (action, sourceView, completionHandler) in
            
            let cell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell

            cell.favoriteImageView.isHidden = self.restaurants[indexPath.row].isFavorite
            self.restaurants[indexPath.row].isFavorite = self.restaurants[indexPath.row].isFavorite ? false : true
            
            // Call completion handler to dismiss the action button
            completionHandler(true)
        }
        
        // Configure swipe action 将「喜爱」加入右划动作列表
        favoriteAction.backgroundColor = UIColor.systemYellow
        favoriteAction.image = UIImage(systemName: self.restaurants[indexPath.row].isFavorite ? "heart.slash.fill" : "heart.fill")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [favoriteAction])
            
        return swipeConfiguration

    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurantDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! RestaurantDetailViewController
                destinationController.restaurant = self.restaurants[indexPath.row]
                // 补充代码更新数据，即使用SwiftData获取资料
                destinationController.dataStore = self
            }
        } else if segue.identifier == "addRestaurant" {

            if let navController = segue.destination as? UINavigationController,
                let destinationController = navController.topViewController as? NewRestaurantController {
                print("setting the dataStore")
                // 补充代码更新数据，即使用SwiftData获取资料
                destinationController.dataStore = self
            }

        }
    }
    
    // MARK: - fetchData
    func fetchRestaurantData() {
        print("Fetching restaurant data...")
        let descriptor = FetchDescriptor<Restaurant>()
        restaurants = (try? container?.mainContext.fetch(descriptor)) ?? []
        updateSnapshot()
        //print("????")
    }
    
    func updateSnapshot(animatingChange:Bool = false) {
        
        // create a snapshot and populate the data 建立一个快照
        var snapshot = NSDiffableDataSourceSnapshot<Section, Restaurant>()
        snapshot.appendSections([.all])
        snapshot.appendItems(restaurants, toSection: .all)

        dataSource.apply(snapshot, animatingDifferences: animatingChange)
        
        tableView.backgroundView?.isHidden = restaurants.count == 0 ? false : true
        //print("更新视图中")
    }
    
    // 声明一个方法以使用回退segue
    @IBAction func close(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
}
