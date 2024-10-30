//
//  NewRestaurantControllerTableViewController.swift
//  FoodPin
//
//  Created by zhiye on 2024/10/30.
//

import UIKit

class NewRestaurantController: UITableViewController {

    // 针对每一个文字栏玉文字视图建立Outlet变量
    @IBOutlet var nameTextField: RoundedTextField! {
        didSet {
            nameTextField.tag = 1
            nameTextField.becomeFirstResponder()
            nameTextField.delegate = self
        }
    }
    
    @IBOutlet var typeTextField: RoundedTextField! {
        didSet {
            typeTextField.tag = 2
            typeTextField.delegate = self
        }
    }
    
    @IBOutlet var addressTextField: RoundedTextField! {
        didSet {
            addressTextField.tag = 3
            addressTextField.delegate = self
        }
    }
    
    @IBOutlet var phoneTextField: RoundedTextField! {
        didSet {
            phoneTextField.tag = 4
            phoneTextField.delegate = self
        }
    }
    
    @IBOutlet var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.tag = 5
            descriptionTextView.layer.cornerRadius = 10.0
            descriptionTextView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet var photoImageView: UIImageView! {
        didSet {
            photoImageView.layer.cornerRadius = 10.0
            photoImageView.layer.masksToBounds = true
        }
    }
    
    // 自定导航栏
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // customize the navigation bar appearance
        if let appearance = navigationController?.navigationBar.standardAppearance {// 获取导航栏
            if let custonFont = UIFont(name: "Nunito-Bold", size: 40.0) {
                
                appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!, .font: custonFont]
            }
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
        // 获取父视图的布局
        let margins = photoImageView.superview!.layoutMarginsGuide
        // 关闭自动调整大小遮罩，以程序来使用自动布局
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        // 定位图片的前线为margin的前边线
        photoImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        // 定位图片视图的后线为(magin的后线)为(边距的后边线)
        photoImageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        // 定位图片视图的顶部边线为 magin的 (边距的顶部边线)
        photoImageView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        // 定位图片视图的底部边线为 magin为(边距的底部边线)
        photoImageView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
        // 使用者点击空白的时候返回键盘
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    
    // MARK: - 使用UIImagePickerController来呈现照片库
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            // 使用UIAlertController建立一个动作选单
            let photoSourceRequestController = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .actionSheet)
            // 「拍摄照片」动作
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
                (action) in if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .camera
                    imagePicker.delegate = self // 补充了这段代码来使得extension协议可以运行
                    // 将action加入选单
                    self.present(imagePicker, animated: true, completion: nil)
                }
            })
            // 「图库」动作
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: {
                (action) in if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.delegate = self
                    self.present(imagePicker, animated: true, completion: nil)
                }
            })
            // 「取消」动作
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            // add action
            photoSourceRequestController.addAction(cameraAction)
            photoSourceRequestController.addAction(photoLibraryAction)
            photoSourceRequestController.addAction(cancelAction)
            
            // for ipad
            if let popoverController = photoSourceRequestController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            present(photoSourceRequestController, animated: true, completion: nil)
        }
        
    }
}

// MARK: - 采用UITextFieldDelegate协定
extension NewRestaurantController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }// 上述方法将目前的标签值加一并呼叫view.viewWithTag来获取下一个文字栏，呼叫resign()来移除当前文字栏的焦点，并让下一个文字栏成为第第一个回应者
        
        return true
    }
}


// MARK: - 采用UIIMagePickerControllerDelegate 协定
extension NewRestaurantController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoImageView.image = selectedImage
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true
        }
        // 呼叫dismiss方法来取消图片选择器
        dismiss(animated: true, completion: nil)
    }
}
