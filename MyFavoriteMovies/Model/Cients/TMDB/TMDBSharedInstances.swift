//
//  TMDBSharedInstances.swift
//  MyFavoriteMovies
//
//  Created by Mohamed Mohsen on 5/25/19.
//  Copyright © 2019 Mohamed Mohsen. All rights reserved.
//

import Foundation


extension TMDBClient{
    
    private struct Singleton {
        static var sharedInstance = TMDBClient()
    }
    
    static func sharedInstance() -> TMDBClient{
        return Singleton.sharedInstance
    }
}
