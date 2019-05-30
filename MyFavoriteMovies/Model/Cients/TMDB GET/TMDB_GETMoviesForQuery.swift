//
//  TMDB_GETMoviesForQuery.swift
//  MyFavoriteMovies
//
//  Created by Mohamed Mohsen on 5/30/19.
//  Copyright © 2019 Mohamed Mohsen. All rights reserved.
//

import UIKit

//MARK: Search For Movies
extension TMDBClient{
    func getMoviesForSearchString(_ searchString: String, completionHandlerForMovies: @escaping (_ result: [TMDBMovie]?, _ error: NSError?) -> Void) -> URLSessionDataTask? {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [TMDBClient.ParameterKeys.Query: searchString]
        
        /* 2. Make the request */
        let task = taskForGETMethod(Methods.SearchMovie, parameters: parameters as [String:AnyObject]) { (data, error) in
            
            /* 5. Parse the data */
            let searchMoviesResults: MoviesResults?
            do{
                searchMoviesResults = try JSONDecoder().decode(MoviesResults.self, from: data!)
                print("Search Movies - Success")
            }catch let error{
                completionHandlerForMovies(nil, NSError(domain: "getMoviesForSearchString parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse data to watched list movies results.\(error)"]))
                return
            }
            
            /* GUARD: Success = true */
            guard searchMoviesResults?.status_message == nil else {
                completionHandlerForMovies(nil, NSError(domain: "getMoviesForSearchString parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to decode the data correctly! \(searchMoviesResults!.status_message!)"]))
                return
            }
            
            /* 6. Use the data! */
            completionHandlerForMovies(searchMoviesResults?.results!, nil)
        }
        return task
    }
}
