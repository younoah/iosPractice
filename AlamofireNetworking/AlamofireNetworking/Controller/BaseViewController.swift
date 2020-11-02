//
//  BaseViewController.swift
//  AlamofireNetworking
//
//  Created by uno on 2020/10/30.
//

import UIKit
import Toast_Swift

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 인증 실패 노티피케이션 등록
        NotificationCenter.default.addObserver(self, selector: #selector(showErrorPopUp(notification:)), name: NSNotification.Name(rawValue: Notification.API.AuthFail), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 인증 실패 노티피케이션 해제
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Notification.API.AuthFail), object: nil)
    }

}

// MARK:- Methods
extension BaseViewController {
    
    @objc func showErrorPopUp(notification: NSNotification) {
        print("BaseViewController - showErrorPopUp() called")
        
        if let data = notification.userInfo?["statusCode"] {
            print("showErrorPopUp() data: \(data)")
            
            // UI는 메인쓰레드에서 돌리기
            DispatchQueue.main.async {
                self.view.makeToast("\(data)에러 입니다.", duration: 2.0, position: .center)
            }
        }
    }
    
}
