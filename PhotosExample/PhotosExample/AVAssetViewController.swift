//
//  AVAssetViewController.swift
//  PhotosExample
//
//  Created by uno on 2020/10/25.
//

import UIKit

class AVAssetViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        print(VideoModel.shared.videoAseet!)
        imageView.image = VideoModel.shared.videoImage!
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
