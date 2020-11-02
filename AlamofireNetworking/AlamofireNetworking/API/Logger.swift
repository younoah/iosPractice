//
//  Logger.swift
//  AlamofireNetworking
//
//  Created by uno on 2020/11/02.
//

import Foundation
import Alamofire

final class MyLogger: EventMonitor {
    
    // 디스패치큐 설정, 동기/비동기 준비
    let queue = DispatchQueue(label: "MyLogger")
    
    // API요청 결과로 Request 부분 가져오기 
    func requestDidResume(_ request: Request) {
        print("MyLogger - requestDidResume() called")
        debugPrint(request)
    }
    
    // API요청 결과로 Response 부분
    // status코드를 가지고오기 등 여러가지 설정을 할 수 있다.
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("MyLogger - request() called")
        debugPrint(response)
    }
    
}

final class MYApiStatusLogger: EventMonitor {
    
    // 디스패치큐 설정, 동기/비동기 준비
    let queue = DispatchQueue(label: "MYApiStatusLogger")
    
    // API요청 결과로 Response 부분
    // status코드를 가지고오기 등 여러가지 설정을 할 수 있다.
    func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
        
        // Requset에 따른 Response의 status 코드를 가지고온다.
        guard let statusCode = request.response?.statusCode else { return }
        
        print("MYApiStatusLogger - request() called / statusCode: \(statusCode)")
    }
    
}
