//
//  TMDB_GETFavoriteMovies.swift
//  MyFavoriteMovies
//
//  Created by Mohamed Mohsen on 5/30/19.
//  Copyright © 2019 Mohamed Mohsen. All rights reserved.
//

import UIKit

//MARK: Favorites
extension TMDBClient{
    func getFavoriteMovies(_ completionHandlerForFavMovies: @escaping (_ result: [TMDBMovie]?, _ error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [TMDBClient.ParameterKeys.SessionID: TMDBClient.sharedInstance().sessionID!]
        
        var mutableMethod: String = Methods.AccountIDFavoriteMovies
        mutableMethod = substituteKeyInMethod(mutableMethod, key: TMDBClient.URLKeys.UserID, value: String(TMDBClient.sharedInstance().userID!))!
        
        /* 2. Make the request */
        let _ = taskForGETMethod(mutableMethod, parameters: parameters as [String:AnyObject]) { (data, error) in
            
            guard error == nil else{
                completionHandlerForFavMovies(nil, NSError(domain: "getFavoriteMovies parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getFavoriteMovies"]))
                return
            }
            
            /* 5. Parse the data */
            let favoriteMovies: MoviesResults?
            do{
                favoriteMovies = try JSONDecoder().decode(MoviesResults.self, from: data!)
                print("Favorite Movies - Success")
            }catch let error{
                completionHandlerForFavMovies(nil, NSError(domain: "getFavoriteMovies parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse data to favorite movies results.\(error)"]))
                return
            }
            
            /* GUARD: Success = true */
            guard favoriteMovies?.status_message == nil else {
                completionHandlerForFavMovies(nil, NSError(domain: "getFavoriteMovies parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to decode the data correctly! \(favoriteMovies!.status_message!)"]))
                return
            }
            
            /* 6. Use the data! */
            completionHandlerForFavMovies(favoriteMovies?.results!, nil)
        }
    }
}
