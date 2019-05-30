//
//  TMDBClient.swift
//  MyFavoriteMovies
//
//  Created by Mohamed Mohsen on 5/25/19.
//  Copyright © 2019 Mohamed Mohsen. All rights reserved.
//

import Foundation

// MARK: - TMDBClient: NSObject

class TMDBClient: NSObject{
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    // configuration object
    var config = TMDBConfig()
    
    // authentication state
    var requestToken: String? = nil
    var sessionID: String? = nil
    var userID: Int? = nil
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }

    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
    }
    
    // create a URL from parameters
    func tmdbURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters{
            components.queryItems?.append(URLQueryItem(name: key, value: "\(value)"))
        }
        
        return components.url!
    }
    
}



