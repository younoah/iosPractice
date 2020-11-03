//
//  Movie.swift
//  AlamofireNetworkingPractice
//
//  Created by uno on 2020/11/03.
//

import Foundation

struct MovieResponse: Decodable {
    
    let movies: [Movie]
    
}

struct Movie: Codable {
    
    let id, title, date: String
    let grade: Int
    
}
