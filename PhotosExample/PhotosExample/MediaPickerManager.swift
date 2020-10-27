//
//  MediaPickerManager.swift
//  AVFoundationCapture
//
//  Created by 홍창남 on 2018. 5. 22..
//  Copyright © 2018년 홍창남. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import Photos

protocol MediaPickerDelegate: class {
    func didFinishPickingMedia(videoURL: URL)
}

class MediaPickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    weak var mediaPickerDelegate: MediaPickerDelegate?

    lazy var imagePicker: UIImagePickerController = {

        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.mediaTypes = ["public.movie"]
        return imagePicker
    }()
    
    // MARK: Create AVAssetImageGenerator

    func imageGenerator(asset: AVAsset) -> AVAssetImageGenerator {
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.maximumSize = CGSize(width: 600, height: 600)
        
        // 사진을 캡처하는 시간의 오차와 연관된 옵션
        // 별도로 설정하지 않을 경우 offset 값과 실제 사진 결과 시간에 차이가 있을 수 있다.
        imageGenerator.requestedTimeToleranceAfter = CMTimeMake(value: 1, timescale: 600)
        imageGenerator.requestedTimeToleranceBefore = CMTimeMake(value: 1, timescale: 600)
        return imageGenerator
    }

    // MARK: Get thumbnail images from video synchronously and return those as UIImage

    func generateThumbnailSync(url: URL, startOffsets: [Double],
                               completion: @escaping ([UIImage]) -> Void) {
        let asset = AVAsset(url: url)
        let imageGenerator = self.imageGenerator(asset: asset)

        let time: [CMTime] = startOffsets.compactMap {
            return CMTimeMakeWithSeconds(Float64($0), preferredTimescale: asset.duration.timescale)
        }

        let resultImages: [UIImage] = time.compactMap {
            if let image = try? imageGenerator.copyCGImage(at: $0, actualTime: nil) {
                return UIImage(cgImage: image)
            }
            return nil
        }

        completion(resultImages)
    }

    // MARK: Get thumbnail images from video asynchronously and return those as UIImage

    func generateThumnailAsync(url: URL, startOffsets: [Double],
                               completion: @escaping (UIImage) -> Void) {
        let asset = AVAsset(url: url)
        let imageGenerator = self.imageGenerator(asset: asset)

        let time: [NSValue] = startOffsets.compactMap {
            return NSValue(time: CMTimeMakeWithSeconds(Float64($0), preferredTimescale: asset.duration.timescale))
        }

        imageGenerator.generateCGImagesAsynchronously(forTimes: time) { _, image, _, _, _ in
            if let image = image {
                completion(UIImage(cgImage: image))
            }
        }
    }

    // MARK: Pick video from user's album

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType.rawValue] as? String else { return }

        if mediaType == kUTTypeMovie as String {
            if let videoURL = info[UIImagePickerController.InfoKey.mediaURL.rawValue] as? URL {
                mediaPickerDelegate?.didFinishPickingMedia(videoURL: videoURL)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}

extension PHPhotoLibrary {
    static func checkPermission(completion: @escaping (Bool) -> Void) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
            completion(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                    completion(true)
                }
            })
            print("It is not determined until now")
        case .restricted:
            print("User do not have access to photo album.")
            completion(false)
        case .denied:
            print("User has denied the permission.")
            completion(false)
        case .limited:
            print("버전업으로 새로 추가된 내용 limited")
        @unknown default:
            print("unknown default")
        }
    }
}
