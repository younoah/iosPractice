//
//  AFManager.swift
//  AlamofireNetworkingPractice
//
//  Created by uno on 2020/11/03.
//

import Foundation
import Alamofire

final class AlamofireManager {

    static let shared = AlamofireManager()
    
    let interceptors = Interceptor(interceptors: [BaseInterceptor()])
    
    // 세션 설정
    var session: Session
    private init() {
        // 세션에 인터셉터, 이벤트 모니터(로거) 추가
        session = Session(interceptor: interceptors)
    }

}
