//
//  POSTRequests.swift
//  MyFavoriteMovies
//
//  Created by Mohamed Mohsen on 5/30/19.
//  Copyright © 2019 Mohamed Mohsen. All rights reserved.
//

import UIKit

// MARK: POST Methods

extension TMDBClient{
    
    func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: Data, completionHandlerForPOST: @escaping (_ data: Data?, _ error: NSError?) -> Void){
        
        /* 1. Set the parameters */
        var parametersWithApiKey = parameters
        parametersWithApiKey[ParameterKeys.ApiKey] = Constants.ApiKey as AnyObject?
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: self.tmdbURLFromParameters(parametersWithApiKey, withPathExtension: method))
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = Constants.headers
        request.httpBody = jsonBody
        
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            //retur the POST response data
            completionHandlerForPOST(data, nil)
        }
        
        /* 7. Start the request */
        task.resume()
    }
}


