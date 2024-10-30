//
//  Restaurant.swift
//  FoodPin
//
//  Created by Simon Ng on 1/12/2023.
//

import Foundation

struct Restaurant: Hashable {
    // 使用枚举存储对餐厅的评价
    enum Rating:String {
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
    var description: String = ""
    var image: String = ""
    var isFavorite: Bool = false
    var rating: Rating? // 声明一个可选变量
}
