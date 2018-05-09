//
//  ViewController.swift
//  learnswift
//
//  Created by QiHui Yan on 2018/4/26.
//  Copyright © 2018年 QiHui Yan. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet var tableView: UITableView!
    @IBOutlet var uploadPhoto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "测试"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let alert = UIAlertController(title: "提示", message: "添加图片", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let cam = UIAlertAction(title: "相机", style: .default, handler: self.cam(action:))
        let photo = UIAlertAction(title: "从相册选择", style: .default, handler: self.cam(action:))
        alert.addAction(cancel)
        alert.addAction(cam)
        alert.addAction(photo)
        self.present(alert, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            let scrollViewalpha = (300 - (scrollView.contentOffset.y + 64)) / 300
            if scrollViewalpha <= 1 && scrollViewalpha >= 0{
                self.navigationController?.navigationBar.alpha = scrollViewalpha
            }
            UIApplication.shared.statusBarStyle = scrollViewalpha >= 1 ? .lightContent : .default
        }
    }
    
    func cam(action:UIAlertAction)->Void {
        let imagePicker = UIImagePickerController()
        
        let photoAlert = UIAlertController(title: "提示", message: "App需要您的同意,才能访问相册", preferredStyle: .alert)
        let photoCancel = UIAlertAction(title: "不允许", style: .cancel) { (action) in
            print("%@",action)
        }
        
        let photoConfirm = UIAlertAction(title: "好", style: .destructive) { (action) in
            print("%@",action)
        }
        photoAlert.addAction(photoCancel)
        photoAlert.addAction(photoConfirm)
        let settingUrl = URL(string: UIApplicationOpenSettingsURLString)
        
        switch PHPhotoLibrary.authorizationStatus() {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (status:PHAuthorizationStatus) in
                    print(status)
                })
            case .restricted:
                photoAlert.message = "app禁止使用相册"
                self.present(photoAlert, animated: true, completion: nil)
            case .denied:
                self.present(photoAlert, animated: true, completion: {
                    UIApplication.shared.open((settingUrl)!, options: [:], completionHandler: nil)
                })
            case .authorized:
                print("用户允许使用相册")
        }
        
        //检测相机是否可用
        
        let isAvailable = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        //必须首先设置sourceType 然后再设置其他属性 否则会出异常，提示sourceType 必须是 UIImagePickerControllerSourceTypeCamera
        
        imagePicker.sourceType = .photoLibrary
        
        if isAvailable {
            
            imagePicker.sourceType = .camera
            
            //如果有前置摄像头则调用前置摄像头
            
            imagePicker.cameraDevice = .front
            
            //是否显示控制栏,这里选择false会展示系统相机UI，如果要自定义可以将其隐藏
            
            imagePicker.showsCameraControls = false
            
        }
        
        //代理
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.navigationBar.barTintColor = UIColor.orange
        imagePicker.navigationBar.tintColor = UIColor.white
        imagePicker.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.white,
            NSAttributedStringKey.obliqueness : 0.5,
        ]
        //打开相机
        
        present(imagePicker, animated: true,  completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        if selectImage?.cgImage == nil || selectImage?.ciImage == nil {
            NSLog("Error:\(info)")
        }
        
        uploadPhoto.image = selectImage
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let str = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: str)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: str)
        }
        cell?.textLabel?.text = "啦啦啦啦啦啦"
        return cell!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

