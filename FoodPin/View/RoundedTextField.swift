//
//  RoundTextField.swift
//  FoodPin
//
//  Created by zhiye on 2024/10/30.
//

import UIKit

// 建立一个圆角的文字栏位
class RoundedTextField: UITextField {

    // 使用UIEdgeInsets来缩减矩形
    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    // 返回的绘制矩形针对文字栏的文字
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    // 返回的矩形针对文字栏的占位符号
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    // 返回的矩形用于显示可编辑的文字
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.systemGray5.cgColor
        self.layer.cornerRadius = 10.0 // 设置圆角
        self.layer.masksToBounds = true
    }
}
