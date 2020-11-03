//
//  Router.swift
//  AlamofireNetworkingPractice
//
//  Created by uno on 2020/11/03.
//

import Foundation
import Alamofire

// 검색 관련 api
enum MyRouter: URLRequestConvertible {
    
    case getMovies(term: Int)
    
    var baseURL: URL {
        return URL(string: API.baseURL)!
    }
    
    // 메서드 설정
    var method: HTTPMethod {
        switch self {
        case .getMovies:
            return .get
        }
    }
    
    // 엔드포인트
    var path: String {
        switch self {
        case .getMovies:
            return "movies/"
        }
    }
    
    // 파라미터 설정
    var parameters : [String : Int] {
        switch self {
        // enum으로 정의한 녀석을 switch문에서 사용하려면 let을 사요해야한다.
        case let .getMovies(term):
            return ["order_type" : term]
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
        request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        
        return request
    }
}
