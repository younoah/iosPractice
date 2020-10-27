//
//  ViewController.swift
//  PhotosExample
//
//  Created by uno on 2020/10/24.
//

import UIKit
import MobileCoreServices
import Photos
//import AVFoundation

class BasicPhotoViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    let picker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
    }

}

// MARK:- Methods
extension BasicPhotoViewController {
    
    @IBAction func addAction(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary() }
        let camera = UIAlertAction(title: "카메라", style: .default) { (action) in self.openCamera() }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    func openLibrary() {
        picker.sourceType = .photoLibrary
//        picker.mediaTypes = [kUTTypeMovie as String]
        picker.mediaTypes = ["public.movie"]
        present(picker, animated: false, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        } else {
            print("Camera not avaliable")
        }
    }
}

extension BasicPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 사진을 선택하고, 끝나고 난 이후 메서드 정의
    // info 미디어(사진)정보가 담겨서 온다.
    // info는 3쌍으로 이루어진 딕셔너리이다.
    // Type, URL, UIImage값(UIImagePickerControllerOriginalImage)
    // info에서 UIImagePickerControllerOriginalImage 키를 가지는 UIimage를 통해서 이미지를 가지고 올수 있다.
    // 이미지 피커 컨트롤러 델리게이트 메서드를 사용하면 자동으로 디스미스 되지 않기 때문에 꼭 디스미스를 작성해 넣어야한다.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        // image
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            print(info)
        }
        
        // URL - 사라짐
        //if let imageUrl = info[UIImagePickerController.InfoKey.referenceURL] as? URL{
        //    print(imageUrl)
        //}
        
        // PHAsset
        if let asset = info[UIImagePickerController.InfoKey.phAsset] {
            print(asset)
          }
        
        // 이미지 이름
//        if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
//            if let fileName = (asset.value(forKey: "filename")) as? String {
//                print(fileName)
//            }
//        }
        
        // document directory
//        if let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first{
//            print(documentDirectory)
//
//            // 이미지 URL
//            let photoURL = URL(fileURLWithPath: documentDirectory)
//            print(photoURL)
//        }
       

        
        dismiss(animated: true, completion: nil)
    }
}
