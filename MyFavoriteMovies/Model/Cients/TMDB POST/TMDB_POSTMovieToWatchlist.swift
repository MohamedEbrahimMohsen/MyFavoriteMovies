//
//  TMDB_POSTMovieToWatchlist.swift
//  MyFavoriteMovies
//
//  Created by Mohamed Mohsen on 5/30/19.
//  Copyright © 2019 Mohamed Mohsen. All rights reserved.
//

import UIKit

// MARK: POST Watchlist Movie
extension TMDBClient{
    func postToWatchlist(_ movie: TMDBMovie, watchlist: Bool, completionHandlerForWatchlist: @escaping (_ success: Bool?, _ error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [TMDBClient.ParameterKeys.SessionID : TMDBClient.sharedInstance().sessionID!]
        var mutableMethod: String = Methods.AccountIDWatchlist
        mutableMethod = substituteKeyInMethod(mutableMethod, key: TMDBClient.URLKeys.UserID, value: String(TMDBClient.sharedInstance().userID!))!
        
        let moviePostData = WatchlistMovie(media_type: "movie", media_id: movie.id!, watchlist: watchlist)
        
        let postJSONData: Data?
        do{
            postJSONData = try JSONEncoder().encode(moviePostData)
        }catch let error{
            completionHandlerForWatchlist(false, error as NSError)
            return
        }
        
        self.taskForPOSTMethod(mutableMethod, parameters: parameters as [String : AnyObject], jsonBody: postJSONData!) { (data, error) in
            /* 5. Parse the data */
            let response: POSTResponse?
            do{
                response = try JSONDecoder().decode(POSTResponse.self, from: data!)
            }catch let error{
                completionHandlerForWatchlist(false, error as NSError)
                return
            }
            
            /* GUARD: Success = true */
            guard (response?.success())! || (response?.update())! else {
                completionHandlerForWatchlist(false, NSError(domain: "postToWatchlist parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to decode the data correctly! \(response!.status_message!)"]))
                return
            }
            
            print("POST Watchlist Response Movies - Success")
            completionHandlerForWatchlist(true, nil)
        }
        
    }
}
