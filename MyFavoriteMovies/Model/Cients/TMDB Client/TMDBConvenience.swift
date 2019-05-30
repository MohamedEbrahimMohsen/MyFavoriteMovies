//
//  TMDBConvenience.swift
//  MyFavoriteMovies
//
//  Created by Mohamed Mohsen on 5/26/19.
//  Copyright © 2019 Mohamed Mohsen. All rights reserved.
//

import Foundation
import UIKit

extension TMDBClient{
    // MARK: Authentication (GET) Methods
    /*
     Steps for Authentication...
     https://www.themoviedb.org/documentation/api/sessions
     
     Step 1: Create a new request token
     Step 2a: Ask the user for permission via the website
     Step 3: Create a session ID
     Bonus Step: Go ahead and get the user id 😄!
     */
    
    func authenticateWithViewController(_ hostViewController: UIViewController, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        getRequestToken() {success, requestToken, errorString in
            guard success == true else{
                completionHandlerForAuth(false, errorString!)
                return
            }
            self.requestToken = requestToken
            
            self.loginWithToken(requestToken, hostViewController: hostViewController){ (success, errorString) in
                guard success == true else{
                    completionHandlerForAuth(false, errorString)
                    return
                }
                
                self.getSessionID(requestToken) { (success, sessionID, errorString) in
                    guard success == true else{
                        completionHandlerForAuth(false, errorString)
                        return
                    }
                    self.sessionID = sessionID
                    
                    self.getUserID{ (success, userID, errorString) in
                        guard success == true else{
                            completionHandlerForAuth(false, errorString)
                            return
                        }
                        self.userID = userID
                        completionHandlerForAuth(true, nil)
                    }
                }
            }
        }
    }
    
    private func getRequestToken(_ completionHandlerForToken: @escaping (_ success: Bool, _ requestToken: String?, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String:AnyObject]()
        
        /* 2. Make the request */
        let _ = taskForGETMethod(Methods.AuthenticationTokenNew, parameters: parameters) { (data, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            guard error == nil else {
                print(error!)
                completionHandlerForToken(false, nil, "Login Failed (Request Token).")
                return
            }
            
            let requestedToken: RequestToken?
            do{
                requestedToken = try JSONDecoder().decode(RequestToken.self, from: data!)
                
                guard let request_token = requestedToken?.request_token else{
                    completionHandlerForToken(false, nil, "Login Failed (Request Token Not Found).")
                    return
                }
                
                completionHandlerForToken(true, request_token, "Login succeeded (Request Token).")
                print("Request Token - Success")
            }catch let error{
                print(error)
                completionHandlerForToken(false, nil, "Login Failed (Request Token).")
            }
        }
    }

    /* This function opens a TMDBAuthViewController to handle Step 2a of the auth flow */
    private func loginWithToken(_ requestToken: String?, hostViewController: UIViewController, completionHandlerForLogin: @escaping (_ success: Bool, _ errorString: String?) -> Void) {

        let authorizationURL = URL(string: "\(TMDBClient.Constants.AuthorizationURL)\(requestToken!)")
        let request = URLRequest(url: authorizationURL!)
        
        let webAuthViewController = hostViewController.storyboard!.instantiateViewController(withIdentifier: "TMDBAuthViewController") as! TMDBAuthViewController

        webAuthViewController.urlRequest = request
        webAuthViewController.requestToken = requestToken
        webAuthViewController.completionHandlerForView = completionHandlerForLogin

        let webAuthNavigationController = UINavigationController()
        webAuthNavigationController.pushViewController(webAuthViewController, animated: false)
        
        performUIUpdatesOnMain {
            hostViewController.present(webAuthNavigationController, animated: true, completion: nil)
        }
    }
    
    private func getSessionID(_ requestToken: String?, completionHandlerForSession: @escaping (_ success: Bool, _ sessionID: String?, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [TMDBClient.ParameterKeys.RequestToken: requestToken!]
        
        /* 2. Make the request */
        let _ = taskForGETMethod(Methods.AuthenticationSessionNew, parameters: parameters as [String:AnyObject]) { (data, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            guard error == nil else {
                print(error!)
                completionHandlerForSession(false, nil, "Login Failed (Session ID).")
                return
            }
            
            let session: Session?
            do{
                session = try JSONDecoder().decode(Session.self, from: data!)
                
                guard session?.success != nil && session?.success == true else{
                    completionHandlerForSession(false, nil, "Login Failed (Session ID).")
                    return
                }
                
                completionHandlerForSession(true, session?.session_id, "Login succeeded (Session ID).")
                print("Session ID - Success")
            }catch let error{
                print(error)
                completionHandlerForSession(false, nil, "Login Failed (Session ID).")
            }
        }
    }
    
    private func getUserID(_ completionHandlerForUserID: @escaping (_ success: Bool, _ userID: Int?, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [TMDBClient.ParameterKeys.SessionID: TMDBClient.sharedInstance().sessionID!]
        
        /* 2. Make the request */
        let _ = taskForGETMethod(Methods.Account, parameters: parameters as [String:AnyObject]) { (data, error) in
            guard error == nil else {
                print(error!)
                completionHandlerForUserID(false, nil, "Login Failed (User ID).")
                return
            }
            
            let user: User?
            do{
                user  = try JSONDecoder().decode(User.self, from: data!)
                guard user?.status_message == nil else{
                    completionHandlerForUserID(false, nil, "Login Failed (User ID).")
                    return
                }
                completionHandlerForUserID(true, user?.id, "Login succeeded (User ID).")
                print("User ID - Success")
            }catch{
                print(error)
                completionHandlerForUserID(false, nil, "Login Failed (User ID).")
            }
        }
    }

    // substitute the key for the value that is contained within the method name
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
}


