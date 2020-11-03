//
//  User.swift
//  AlamofireNetworking
//
//  Created by uno on 2020/11/03.
//

import Foundation

struct UserResponse: Codable {
    let results: [User]
}

struct User: Codable {
    let id: String
    var username: String
}
