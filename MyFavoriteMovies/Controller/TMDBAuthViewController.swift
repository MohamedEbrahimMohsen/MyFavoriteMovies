//
//  TMDBAuthViewController.swift
//  MyFavoriteMovies
//
//  Created by Mohamed Mohsen on 5/26/19.
//  Copyright © 2019 Mohamed Mohsen. All rights reserved.
//

import UIKit
import WebKit

class TMDBAuthViewController: UIViewController {

    // MARK: Properties
    
    var urlRequest: URLRequest? = nil
    var requestToken: String? = nil
    var completionHandlerForView: ((_ success: Bool, _ errorString: String?) -> Void)? = nil
    
    // MARK: Outlets
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self

        navigationItem.title = "TheMovieDB Auth"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAuth))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let urlRequest = urlRequest {
            webView.load(urlRequest)
        }
    }

    // MARK: Cancel Auth Flow
    
    @objc func cancelAuth() {
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - TMDBAuthViewController: UIWebViewDelegate

extension TMDBAuthViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        // if user has to login, this will redirect them back to the authorization url
        if webView.url!.absoluteString.contains(TMDBClient.Constants.AccountURL) {
            if let urlRequest = urlRequest {
                webView.load(urlRequest)
            }
        }

        if webView.url!.absoluteString == "\(TMDBClient.Constants.AuthorizationURL)\(requestToken!)/allow" {

            dismiss(animated: true) {
                self.completionHandlerForView!(true, nil)
            }
        }
    }

}
