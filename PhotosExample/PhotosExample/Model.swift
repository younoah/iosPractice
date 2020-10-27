//
//  Model.swift
//  PhotosExample
//
//  Created by uno on 2020/10/25.
//

import UIKit
import Photos

class VideoModel {
    static let shared = VideoModel()
    var videoAseet : AVAsset?
    var videoImage : UIImage?
    var videoURL: URL?
    var thumbnailURL: String?
}
