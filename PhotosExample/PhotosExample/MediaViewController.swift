//
//  ViewController.swift
//  AVFoundationCapture
//
//  Created by 홍창남 on 2018. 5. 13..
//  Copyright © 2018년 홍창남. All rights reserved.
//

import UIKit
import Photos

class MediaViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    let mediaPickerManager = MediaPickerManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        mediaPickerManager.mediaPickerDelegate = self
    }

    @IBAction func imageBtnTapped(_ sender: UIButton) {
        PHPhotoLibrary.checkPermission { isSuccess in
            DispatchQueue.main.async {
                if isSuccess {
                    self.present(self.mediaPickerManager.imagePicker, animated: true, completion: nil)
                }
            }
        }
    }
}

extension MediaViewController: MediaPickerDelegate {
    func didFinishPickingMedia(videoURL: URL) {
        let captureTime: [Double] = [12, 2, 3, 4]

        // images will be created at each capture times.
        mediaPickerManager.generateThumbnailSync(url: videoURL, startOffsets: captureTime) { images in
            self.imageView.image = images.first!
            VideoModel.shared.videoImage = images.first!
            VideoModel.shared.videoAseet = AVAsset(url: videoURL)
            print(images)
        }
    }
}


