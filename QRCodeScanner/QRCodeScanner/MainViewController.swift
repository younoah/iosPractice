//
//  ViewController.swift
//  QRCodeScanner
//
//  Created by uno on 2020/10/27.
//

import UIKit
// 웹킷을 사용하기 위해서는 프로젝트파일에 라이브러리를 웹킷 라이브러리를 추가해야한다.
// 프로젝트파일 - Build Phases - Link Binary With Library - WebKit.Framework 추가
import WebKit
import AVFoundation
import QRCodeReader

class MainViewController: UIViewController {
    
    // MARK:- Properties
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var qrCodeButton: UIButton!
    
    // QR코드 리더 뷰컨트롤러를 만든다.
    // Good practice: create the reader lazily to avoid cpu overload during the
    // initialization and each time we need to scan a QRCode
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            
            // Configure the view controller (optional)
            $0.showTorchButton        = false
            $0.showSwitchCameraButton = false
            $0.showCancelButton       = false
            $0.showOverlayView        = true
            $0.rectOfInterest         = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showWebView()
        configureButton()
    }

}

// MARK:- Configure UI
extension MainViewController {
    
    func configureButton() {
        qrCodeButton.layer.borderWidth = 3
        qrCodeButton.layer.borderColor = UIColor.blue.cgColor
        qrCodeButton.layer.cornerRadius = 10
        qrCodeButton.addTarget(self, action: #selector(showScanner), for: .touchUpInside)
    }
    
}

// MARKL:- Methodd
extension MainViewController {
    
    func showWebView() {
        print("MainViewController - showWebView() called ")
        guard let url  = URL(string: "https://www.naver.com/") else { return }
        let requestObj = URLRequest(url: url)
        webView.load(requestObj)
    }
    
    @objc fileprivate func showScanner() {
        print("MainViewController - showScanner() called ")
        // Retrieve the QRCode content
        // By using the delegate pattern
        // 델리게이트 메서드 혹은 클로저패턴으로 qr코드 인식 이후를 정의한다.
        readerVC.delegate = self

        // Or by using the closure pattern
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            print("QRCodeScanner succeded in closure")
            guard let result = result else { return }
            print(result)
            let scannedUrlString = result.value
            print("scannedUrlString : \(scannedUrlString)")
            guard let scannedUrl = URL(string: scannedUrlString) else { return }
            self.webView.load(URLRequest(url: scannedUrl))
        }

        // Presents the readerVC as modal form sheet
        readerVC.modalPresentationStyle = .formSheet
        
        // 설정된 QR코드 뷰 컨트롤러를 화면에 보여준다.
        present(readerVC, animated: true, completion: nil)
    }
    
}

// MARKL:- QRCode Reader ViewController Delegate
extension MainViewController: QRCodeReaderViewControllerDelegate {
    
    // QR코드 리더가 성공 했을때 동작 정의
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        print("QRCodeScanner succeded in delegate")
        reader.stopScanning()

        dismiss(animated: true, completion: nil)
    }
    
    // QR코드 리더가 취소 됬을때 정의
    // 모달을 내렸는데 반응을 안한다... 
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        print("QRCodeScanner stoped")
        reader.stopScanning()

        dismiss(animated: true, completion: nil)
    }
    
}
