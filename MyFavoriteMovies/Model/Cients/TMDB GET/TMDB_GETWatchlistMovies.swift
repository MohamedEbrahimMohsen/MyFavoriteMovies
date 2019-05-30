//
//  TMDB_GETWatchlistMovies.swift
//  MyFavoriteMovies
//
//  Created by Mohamed Mohsen on 5/30/19.
//  Copyright © 2019 Mohamed Mohsen. All rights reserved.
//

import UIKit


//MARK: WatchList
extension TMDBClient{
    func getWatchlistMovies(_ completionHandlerForWatchlist: @escaping (_ result: [TMDBMovie]?, _ error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [TMDBClient.ParameterKeys.SessionID: TMDBClient.sharedInstance().sessionID!]
        var mutableMethod: String = Methods.AccountIDWatchlistMovies
        mutableMethod = substituteKeyInMethod(mutableMethod, key: TMDBClient.URLKeys.UserID, value: String(TMDBClient.sharedInstance().userID!))!
        
        /* 2. Make the request */
        let _ = taskForGETMethod(mutableMethod, parameters: parameters as [String:AnyObject]) { (data, error) in
            
            /* 5. Parse the data */
            let watchlistMovies: MoviesResults?
            do{
                watchlistMovies = try JSONDecoder().decode(MoviesResults.self, from: data!)
                print("WatchList Movies - Success")
            }catch let error{
                completionHandlerForWatchlist(nil, NSError(domain: "getWatchListMovies parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse data to watched list movies results.\(error)"]))
                return
            }
            
            /* GUARD: Success = true */
            guard watchlistMovies?.status_message == nil else {
                completionHandlerForWatchlist(nil, NSError(domain: "getWatchListMovies parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to decode the data correctly! \(watchlistMovies!.status_message!)"]))
                return
            }
            
            /* 6. Use the data! */
            completionHandlerForWatchlist(watchlistMovies?.results!, nil)
        }
    }
}
