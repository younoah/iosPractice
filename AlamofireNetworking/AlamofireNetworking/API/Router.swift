//
//  Router.swift
//  AlamofireNetworking
//
//  Created by uno on 2020/11/03.
//

import Foundation
import Alamofire

// 검색 관련 api
enum MyRouter: URLRequestConvertible {
    
//    case get([String: String])
//    case post([String: String])
    
    case searchPhotos(term: String)
    case searchUsers(term: String)
    
    var baseURL: URL {
        return URL(string: API.baseURL + "search/")!
    }
    
    // 메서드 설정
    
    // MyRouter를 통해서 api를 호출하는데 타입이 searchPhotos일때 http메서드를 get으로 하겠다.
    // MyRouter를 통해서 api를 호출하는데 타입이 searchUsers일때 http메서드를 post으로 하겠다.
//    var method: HTTPMethod {
//        switch self {
//        case .searchPhotos:
//            return .get
//        case .searchUsers:
//            return .post
//        }
//    }
    
    // MyRouter를 통해서 api를 호출하는데 타입이 searchPhotos와 searchPhotos일때 http메서드를 get으로 하겠다.
    var method: HTTPMethod {
        switch self {
        case .searchPhotos, .searchUsers:
            return .get
        }
    }
    
    // 엔드포인트
    // 타입이 searchPhotos일때 엔드포인트(url 끝 경로를) "photos/"로 하겠다.
    // 타입이 searchUsers일때 엔드포인트(url 끝 경로를) "users/"로 하겠다.
    var path: String {
        switch self {
        case .searchPhotos:
            return "photos/"
        case .searchUsers:
            return "users/"
        }
    }
    
    // 파라미터 설정
    
    // searchPhotos일때 쿼리문을 "query1" : term 로 한다.
    // searchUsers일때 쿼리문을 "query2" : term 로 한다.
//    var parameters : [String : String] {
//        switch self {
//        // enum으로 정의한 녀석을 switch문에서 사용하려면 let을 사요해야한다.
//        case let .searchPhotos(term),
//             return ["query1" : term]
//        case let .searchUsers(term):
//            return ["query2" : term]
//        }
//    }
    
    // searchPhotos와 searchUsers일때 쿼리문을 "query" : term 로 한다.
    var parameters : [String : String] {
        switch self {
        // enum으로 정의한 녀석을 switch문에서 사용하려면 let을 사요해야한다.
        case let .searchPhotos(term), let .searchUsers(term):
            return ["query" : term]
        }
    }
    
    // api를 호출할때 실제로 발동되는 부분
    func asURLRequest() throws -> URLRequest {
        
        // url 설정부분
        let url = baseURL.appendingPathComponent(path)
        print("MyRouter = asURLRequest() called / url : \(url)")
        var request = URLRequest(url: url)
        
        // 메서드 설정 부분
        request.method = method
        
        // 파라미터 설정
        // throws안에서는 try만 하면 된다. throws는 밖으로 에러를 뱉어낸다.
        request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        
//        switch self {
//        case let .get(parameters):
//            request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
//        case let .post(parameters):
//            request = try JSONParameterEncoder().encode(parameters, into: request)
//        }
        
        return request
    }
}
