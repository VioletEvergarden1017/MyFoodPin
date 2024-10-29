//
//  RestaurantDetailSeparatorCell.swift
//  FoodPin
//
//  Created by zhiye on 2024/10/28.
//

import UIKit
import MapKit

class RestaurantDetailMapCell: UITableViewCell {

    @IBOutlet var mapView: MKMapView! {
        didSet {
            // 设置圆角
            mapView.layer.cornerRadius = 20.0
            mapView.clipsToBounds = true
        }
    }
    
    // 添加一个方法获取餐厅的地址作为参数，来在地图上显示一个标记
    func configure(location: String) {
        // 取得位置
        let geoCoder = CLGeocoder()
        print(location)
        geoCoder.geocodeAddressString(location, completionHandler: {
            placemarks, error in
            // 错误处理
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let placemakrs = placemarks {
                // 取得第一个地点标记
                let placemark = placemakrs[0]
                // 加上标记
                let annotation = MKPointAnnotation()
                if let location = placemark.location {
                    // 显示标记
                    annotation.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotation)
                    // 设定缩放程度
                    let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
                    self.mapView.setRegion(region, animated: false)
                }
            }
        })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
