//
//  RestaurantDiffableDataSource.swift
//  FoodPin
//
//  Created by Simon Ng on 1/12/2023.
//

import UIKit

enum Section {
    case all
}

class RestaurantDiffableDataSource: UITableViewDiffableDataSource<Section, Restaurant> {

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

}
