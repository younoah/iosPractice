//
//  API.swift
//  AlamofireNetworkingPractice
//
//  Created by uno on 2020/11/03.
//

import Foundation

enum API {
    static let baseURL = "https://api.unsplash.com/"
}


enum MyError: String, Error {
    case noContent = "😭검색 결과가 없습니다."
}
