//
//  TMDB_GETPlayingNowMovies.swift
//  MyFavoriteMovies
//
//  Created by Mohamed Mohsen on 5/30/19.
//  Copyright © 2019 Mohamed Mohsen. All rights reserved.
//

import UIKit

//MARK: Playing Now Movies
extension TMDBClient{
    func getPlayingNowMovies(_ completionHandlerForPlayingNowMovies: @escaping (_ result: [TMDBMovie]?, _ error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [TMDBClient.ParameterKeys.SessionID: TMDBClient.sharedInstance().sessionID!]
        
        let method: String = Methods.MoviesPlayingNow
        
        /* 2. Make the request */
        let _ = taskForGETMethod(method, parameters: parameters as [String:AnyObject]) { (data, error) in
            
            guard error == nil else{
                completionHandlerForPlayingNowMovies(nil, NSError(domain: "getPlayingNowMovies parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getPlayingNowMovies"]))
                return
            }
            
            /* 5. Parse the data */
            let latestMovies: MoviesResults?
            do{
                latestMovies = try JSONDecoder().decode(MoviesResults.self, from: data!)
                print("Latest Movies - Success")
            }catch let error{
                completionHandlerForPlayingNowMovies(nil, NSError(domain: "getPlayingNowMovies parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse data to get the latest movies results.\(error)"]))
                return
            }
            
            /* GUARD: Success = true */
            guard latestMovies?.status_message == nil else {
                completionHandlerForPlayingNowMovies(nil, NSError(domain: "getPlayingNowMovies parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to decode the data correctly! \(latestMovies!.status_message!)"]))
                return
            }
            
            /* 6. Use the data! */
            completionHandlerForPlayingNowMovies(latestMovies?.results!, nil)
        }
    }
}
