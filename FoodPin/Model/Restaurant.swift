//
//  Restaurant.swift
//  FoodPin
//
//  Created by Simon Ng on 1/12/2023.
//

import UIKit
import SwiftData


@Model class Restaurant {// 将Restaurant结构转化为模型类
    
    enum Rating:String, CaseIterable {
        case awesome
        case good
        case okay
        case bad
        case terrible
        
        var image: String {
            switch self {
            case .awesome: return "love"
            case .good: return "cool"
            case .okay: return "happy"
            case .bad: return "sad"
            case .terrible: return "angry"
            }
        }
    }
    
    var name: String = ""
    var type: String = ""
    var location: String = ""
    var phone: String = ""
    var summary: String = ""
    
    @Attribute(.externalStorage) var imageData = Data() // 对于原来的image属性将其转换成 imageData，类型为Data
    // 添加了一个计算属性image，负责将图像转换成UIImage对象
    @Transient var image: UIImage {
        get {
            UIImage(data: imageData) ?? UIImage()
        }
        set {
            self.imageData = newValue.pngData() ?? Data()
        }
    }
    
    var isFavorite: Bool = false
    
    // rating是枚举型（计算属性 computed property），负责处理评分文本的转换
    @Transient var rating: Rating? { // 使用Transient对rating进行了注释，表面SwiftData不存储rating在数据库当中
        get {
            guard let ratingText = ratingText else {
                return nil
            }
            return Rating(rawValue: ratingText) // 在getter当中将ratingText转换成枚举型
        }
            set {
                self.ratingText = newValue?.rawValue // 在setter中将枚举类型的原始值赋值给ratingText
            }
        }
    @Attribute(originalName: "rating") var ratingText: Rating.RawValue? // 存储ratingText
        
    init(name: String = "", type: String = "", location: String = "", phone: String = "", description: String = "", image: UIImage = UIImage(), isFavorite: Bool = false, rating: Rating? = nil) {
        self.name = name
        self.location = location
        self.phone = phone
        self.summary = description // 将描述的标识符从description变为summary，因为description是swiftData当中的保留字
        self.image = image
        self.isFavorite = isFavorite
        self.rating = rating
    }
    
}
    


