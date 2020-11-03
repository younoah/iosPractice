//
//  AlamofireManager.swift
//  AlamofireNetworking
//
//  Created by uno on 2020/11/02.
//

import Foundation
import Alamofire
import SwiftyJSON

final class AlamofireManager {
    // 싱글턴 적용
    static let shared = AlamofireManager()
    
    // 인터셉터 : API 호출시 중간에 가로채서 공통 파리미터,JWT등 을 추가한다.
    // 인터셉터를 여러가지로 설정해서 여러가지 넣을수 있다.
    let interceptors = Interceptor(interceptors: [BaseInterceptor()]) 
    
    // 로거 설정 (이벤트 모니터)
    // 이벤트 모니터를 여러가지로 설정해서 여러가지 넣을수 있다.
    let monitors = [MyLogger(), MYApiStatusLogger()] as [EventMonitor]
    
    // 세션 설정
    var session: Session
    
    private init() {
        // 세션에 인터셉터, 이벤트 모니터(로거) 추가
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
    
    func getPhotos(searchTerm userInput: String,
                  completion: @escaping (Result<[Photo], MyError>) -> Void) {
        print("AlamofireManager - getPhtos() called userInput: \(userInput)")
        
        // .validate()를 추가하면 retry()가 작동된다.
        self.session
            .request(MyRouter.searchPhotos(term: userInput))
            .validate(statusCode: 200...400) // status 코드가 200~400일때만 허용한다. 이범위가 아니면 에러가 뜬다.
            .responseJSON(completionHandler: { response in
                
                guard let responseValue = response.value else { return }
                print("responseValue : \(responseValue)")
                let responseJSON = JSON(responseValue)
                print("responseJSON : \(responseJSON)")
                
                let jsonArray = responseJSON["results"]
                
                var photos = [Photo]()
                
                print("jsonArray.count : \(jsonArray.count)")
                
                for (index, subJson): (String, JSON) in jsonArray {
                    print("index: \(index), subJson: \(subJson)")
                    
                    // 데이터 파싱
//                    let thumbnail = subJson["urls"]["thumb"].string ?? ""
//                    let userName = subJson["user"]["username"].string ?? ""
//                    let likesCount = subJson["likes"].intValue ?? 0
//                    let createdAt = subJson["created_at"].string ?? ""
                    guard let thumbnail = subJson["urls"]["thumb"].string,
                          let userName = subJson["user"]["username"].string,
                          let createdAt = subJson["created_at"].string else { return }
                    let likesCount = subJson["likes"].intValue
                    
                    let photoItem = Photo(thumnail: thumbnail, username: userName, likesCount: likesCount, createdAt: createdAt)
                    
                    // 배열에 넣고
                    photos.append(photoItem)
                }
                
                if photos.count > 0{
                    completion(.success(photos))
                } else {
                    completion(.failure(.noContent))
                }
                
        })
    }

}
