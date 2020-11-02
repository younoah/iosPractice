//
//  BaseInterceptor.swift
//  AlamofireNetworking
//
//  Created by uno on 2020/11/02.
//

import Foundation
import Alamofire

class BaseInterceptor: RequestInterceptor  {
    
    // 어답터 : AF.Request() 할때 호출이 되는부분
    // requst에 인터셉트를 적용할수 있다.
    // completion을 꼭 구현해야한다.
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        print("BaseInterceptor = adapt() called")
        var request = urlRequest
        
        // 헤더 추가
        // json 형태로만 받기
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Accept")
        
        // 공통 파라미터 추가
        var dictionary = [String : String]()
        dictionary.updateValue(API.clientID, forKey: "client_id")

        // 딕셔너리((공통)파라미터)를 Request에 추가
        // 에러가 발생할수 있기때문에 do-catch를 한다.
        do {
            request = try URLEncodedFormParameterEncoder().encode(dictionary, into: request)
        } catch {
            print(error)
        }
        
    
        
        // 마지막에 completion()을 실행한다.
        // Requset가 성공(success), 실패(failure) 일때 urlRequest를 넣어준다.
        completion(.success(request))
        
    }
    
    // 재시도(retry) : AF.Request() 할때 정상적으로 작동하지 않을때 재시도 설정
    // 마지막에 completion()을 실행한다.
    // Requset가 정상적으로 작동하지 않을때 재시도(retry), 재시도안함(doNotRetry)를 설정할수 있다.
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        print("BaseInterceptor = retry() called")
        
        guard let statusCode = request.response?.statusCode else {
            completion(.doNotRetry)
            return
        }
        
        let data = ["statusCode" : statusCode]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.API.AuthFail), object: nil, userInfo: data)
        
        completion(.doNotRetry)
    }
}
