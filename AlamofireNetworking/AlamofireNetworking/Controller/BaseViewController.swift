//
//  BaseViewController.swift
//  AlamofireNetworking
//
//  Created by uno on 2020/10/30.
//

import UIKit

class BaseViewController: UIViewController {
    
    var vcTitle = "" {
        didSet {
            print("UserListVC - vcTitle didset() called / vcTitle : \(vcTitle)")
            self.title = vcTitle
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
