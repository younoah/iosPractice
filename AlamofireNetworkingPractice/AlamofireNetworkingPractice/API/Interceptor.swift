//
//  Interceptor.swift
//  AlamofireNetworkingPractice
//
//  Created by uno on 2020/11/03.
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
//        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Accept")
        
        // 공통 파라미터 추가
//        var dictionary = [String : String]()
//        dictionary.updateValue("1", forKey: "order_type")

//        do {
//            request = try URLEncodedFormParameterEncoder().encode(dictionary, into: request)
//        } catch {
//            print(error)
//        }
        
        completion(.success(request))
        
    }
    
    // 재시도(retry) : AF.Request() 할때 정상적으로 작동하지 않을때 재시도 설정
    // 마지막에 completion()을 실행한다.
    // Requset가 정상적으로 작동하지 않을때 재시도(retry), 재시도안함(doNotRetry)를 설정할수 있다.
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("BaseInterceptor = retry() called")
        
        completion(.doNotRetry)
    }
}
