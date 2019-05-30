//
//  Serialization.swift
//  MyFavoriteMovies
//
//  Created by Mohamed Mohsen on 5/14/19.
//  Copyright © 2019 Mohamed Mohsen. All rights reserved.
//

import Foundation

struct RequestToken: Decodable{
    var success: Bool?
    var request_token: String?
}

struct LoginToken: Decodable{
    var success: Bool?
    var expires_at: String?
    var request_token: String?
}

struct Session: Decodable{
    var success: Bool?
    var session_id: String?
}

struct User: Decodable{
    var id: Int?
    var iso_639_1: String?
    var iso_3166_1: String?
    var name: String?
    var include_adult: Bool?
    var username: String?
    var avatar: Avatar?
    
    //in case of failuer
    var status_code: Int?
    var status_message: String?
}

struct Avatar: Decodable{
    var gravatar: Gravatar?
}

struct Gravatar: Decodable{
    var hash: String?
}

struct MoviesResults: Decodable{
    let results: [TMDBMovie]?
    
    let status_code: Int?
    let status_message: String?
}

struct FavoriteMovie: Codable{
    let media_type: String?
    let media_id: Int?
    let favorite: Bool?
}

struct WatchlistMovie: Codable{
    let media_type: String?
    let media_id: Int?
    let watchlist: Bool?
}

struct POSTResponse: Decodable{
    let status_code: Int?
    let status_message: String?
    
    func success() -> Bool{
        return status_code == 1
    }
    
    func update() -> Bool{
        return status_code == 13
    }
}
