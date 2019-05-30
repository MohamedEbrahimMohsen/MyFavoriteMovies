//
//  Movie.swift
//  MyFavoriteMovies
//
//  Created by Mohamed Mohsen on 5/11/19.
//  Copyright © 2019 Mohamed Mohsen. All rights reserved.
//

import Foundation

struct TMDBMovie: Decodable{
    let title: String?
    let id: Int?
    let poster_path: String?
    let vote_average: Double?
    let vote_count: Int?
    let overview: String?
    let release_date: String?    
}

extension TMDBMovie: Equatable{
    static func ==(lhs: TMDBMovie, rhs: TMDBMovie) -> Bool{
        return lhs.id == rhs.id
    }
}
