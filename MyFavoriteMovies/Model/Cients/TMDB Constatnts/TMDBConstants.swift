//
//  TMDBConstants.swift
//  MyFavoriteMovies
//
//  Created by Mohamed Mohsen on 5/25/19.
//  Copyright © 2019 Mohamed Mohsen. All rights reserved.
//

import Foundation

extension TMDBClient{

    
    // MARK: Constants
    struct Constants {
        
        // MARK: API Key
        static let ApiKey = "c079844a7727a8a8c7ae0d796588e774"
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "api.themoviedb.org"
        static let ApiPath = "/3"
        static let AuthorizationURL = "https://www.themoviedb.org/authenticate/"
        static let AccountURL = "https://www.themoviedb.org/account/"
        
        static let headers = ["content-type": "application/json;charset=utf-8"]
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: Account
        static let Account = "/account"
        static let AccountIDFavoriteMovies = "/account/{id}/favorite/movies"
        static let AccountIDFavorite = "/account/{id}/favorite"
        static let AccountIDWatchlistMovies = "/account/{id}/watchlist/movies"
        static let AccountIDWatchlist = "/account/{id}/watchlist"
        
        //MARk: Movies
        static let MoviesPlayingNow = "/movie/now_playing"
        
        // MARK: Authentication
        static let AuthenticationTokenNew = "/authentication/token/new"
        static let AuthenticationSessionNew = "/authentication/session/new"
        
        // MARK: Search
        static let SearchMovie = "/search/movie"
        
        // MARK: Config
        static let Config = "/configuration"
        
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let UserID = "id"
    }

    // MARK: Parameter Keys
    struct ParameterKeys {
        static let ApiKey = "api_key"
        static let SessionID = "session_id"
        static let RequestToken = "request_token"
        static let Query = "query"
        static let Username = "username"
        static let Password = "password"
    }

    // MARK: Poster Sizes
    struct PosterSizes {
        static let RowPoster = TMDBClient.sharedInstance().config.posterSizes[2]
        static let DetailPoster = TMDBClient.sharedInstance().config.posterSizes[4]
    }
}
