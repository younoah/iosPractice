//
//  ViewController.swift
//  AlamofireNetworking
//
//  Created by uno on 2020/10/27.
//

import UIKit
import Toast_Swift

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var tapGesture = UITapGestureRecognizer(target: self, action: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder() // 포커싱
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 키보드 올라가는 이벤트 처리 등록
        // 노티피케이션 등록
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 키보드 올라가는 이벤트 처리 해제
        // 노티피케이션 해제
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 화면 넘어가기 전에 준비
    // 세그를 통해 네비게이션 스택의 다른 뷰컨으로 넘어갈때 발동되는 메서드
    // 즉 다음 뷰컨에 변수에 값을 이전 뷰컨에서 할당하기 위해 사용한다.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("HomeViewController - prepare() called / segue.identifier : \(String(describing: segue.identifier))")
        switch segue.identifier {
        case SegueID.userListVC:
            // 다음 화면의 뷰컨트롤러를 가져온다.
            guard let nextVC = segue.destination as? UserListViewController else { return }
            guard let userInputValue = self.searchBar.text else { return }
            nextVC.vcTitle = userInputValue + " 🧑‍💻"
        case SegueID.photoCollectionVC:
            // 다음 화면의 뷰컨트롤러를 가져온다.
            guard let nextVC = segue.destination as? PhotoCollectionViewController else { return }
            guard let userInputValue = self.searchBar.text else { return }
            nextVC.vcTitle = userInputValue + " 🌄"
        default:
            print("default")
        }
    }

}

// MARK:- Configure
extension HomeViewController {
    
    func configure() {
        searchButton.layer.cornerRadius = 10
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture) // 제스쳐 추가
    }
    
}

// MARK:- Methods
extension HomeViewController {
    
    @IBAction func changedSegment(_ sender: UISegmentedControl) {
        var searchBarTitle = ""
        switch sender.selectedSegmentIndex {
        case 0:
            searchBarTitle = "사진 키워드"
        case 1:
            searchBarTitle = "사용자 이름"
        default:
            searchBarTitle = ""
        }
        searchBar.placeholder = searchBarTitle + " 입력"
        searchBar.becomeFirstResponder() // 포커싱
//        searchBar.resignFirstResponder() // 포커싱 해제
    }
    
    // 검색 버튼 클릭
    @IBAction func touchUpButton(_ sender: UIButton) {
        pushViewController()
    }
    
    // 세그먼트 인덱스에 따른 세그 ID 설정후 세그를 통한 화면 이동
    fileprivate func pushViewController() {
        var segueID = ""
        switch segment.selectedSegmentIndex {
        case 0:
            segueID = SegueID.photoCollectionVC
        case 1:
            segueID = SegueID.userListVC
        default:
            segueID = SegueID.userListVC
        }
        // 세그를 통한 화면이동
        performSegue(withIdentifier: segueID, sender: self)
    }
    
    @objc func showKeyboard(notification: NSNotification) {
        print("HomeViewController - showKeyboard() called")
        // 키보드 사이즈 가져오기
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("keyboardSize.height : \(keyboardSize.height)")
            print("searchButton.frame.origin.y.height : \(searchButton.frame.origin.y)")
            if keyboardSize.height < searchButton.frame.origin.y {
                print("키보드가 버튼을 덮다")
                let distance = keyboardSize.height - searchButton.frame.origin.y
                print("이만큼 덮었다. distance : \(distance)")
                self.view.frame.origin.y = distance - searchButton.frame.height
            }
            
        }
        
        
        //
        
    }
    
    @objc func hideKeyboard() {
        print("HomeViewController - hideKeyboard() called")
        self.view.frame.origin.y = 0
    }
}

// MARK:- UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    
    // 서치바에서 텍스트가 변화 되었을 때 동작
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("서치바 텍스프 변화 내용: \(searchText)")
        if searchText.isEmpty {
            searchButton.isHidden = true
            // 딜레이 주기
            // 딜레이를 주어 검색바의 x버튼을 클릭했을때 포커싱이 되지 않도록 한다.(키보드가 안뜨도록 한다.)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
                searchBar.resignFirstResponder()
            })
        } else {
            searchButton.isHidden = false
        }
    }
    
    // 글자가 입력될 때 동작
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let inputTextCount = searchBar.text?.appending(text).count ?? 0
        
        if inputTextCount >= 12 {
            self.view.makeToast("12자 까지만 입력 가능합니다.", duration: 2.0, position: .center)
            return false
        } else {
            return true
        }
    }
    
    // 키보드에서 검색버튼 클릭시 동작
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("HomeViewController = searchBarSearchButtonClicked()")
        guard let userInputString = searchBar.text else { return }
        
        if userInputString.isEmpty {
            self.view.makeToast("검색 키워드를 입력해주세요.", duration: 2.0, position: .center)
        } else {
            pushViewController()
            searchBar.resignFirstResponder()
        }
    }
    
}

// MARK:- Gesture Recognizer Delegate
extension HomeViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        print("HomeViewController - gestureRecognizer shouldReceive() called")
        
        // 터치로 들어온 뷰가 세그먼트와 검색바일때는 예외 처리
        if touch.view?.isDescendant(of: segment) == true {
            print("세그먼트가 터치되었다.")
            return false
        } else if touch.view?.isDescendant(of: searchBar) == true {
            print("검색바가 터치되었다.")
            return false
        } else {
            print("화면이 터치되었다.")
            view.endEditing(true)
            return true
        }
        
    }
}
