//
//  AlamofireManager.swift
//  AlamofireNetworking
//
//  Created by uno on 2020/11/02.
//

import Foundation
import Alamofire

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
    
}
