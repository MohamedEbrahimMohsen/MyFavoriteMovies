//
//  MovieDetailsViewController.swift
//  MyFavoriteMovies
//
//  Created by Mohamed Mohsen on 5/18/19.
//  Copyright © 2019 Mohamed Mohsen. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var favoriteBtn: UIBarButtonItem!
    @IBOutlet weak var watchlistBtn: UIBarButtonItem!
    
    var movie: TMDBMovie!
    var isFavorite = false
    var isWatchlist = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.isTranslucent = false
    }
    
    private func startLoadingUI(){
        activityIndicator.alpha = 1.0
        activityIndicator.startAnimating()
    }
    
    private func endLoadingUI(){
        self.activityIndicator.alpha = 0.0
        self.activityIndicator.stopAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startLoadingUI()

        guard movie != nil else {
            return
        }
        
        if let title = movie.title{
            self.titleLabel.text = title
        }
        
        if let rate = movie.vote_average{
            self.rateLabel.text = "\(rate) / 10"
        }
        
        if let overview = movie.overview{
            self.overviewLabel.text = overview
        }
                
        isFavorite = false
        
        // is the movie a favorite?
        TMDBClient.sharedInstance().getFavoriteMovies { (movies, error) in
            if let movies = movies {
                if movies.contains(self.movie){
                    self.isFavorite = true
                }
                
                performUIUpdatesOnMain {
                    self.updateUI()
                }
            } else {
                print(error ?? "empty error")
            }
        }
        
        isWatchlist = false
        
        // is the movie on the watchlist?
        TMDBClient.sharedInstance().getWatchlistMovies { (movies, error) in
            if let movies = movies {
                if movies.contains(self.movie){
                    self.isWatchlist = true
                }
                
                performUIUpdatesOnMain {
                    self.updateUI()
                }
            } else {
                print(error ?? "empty error")
            }
        }
        
        // set the poster image
        if let posterPath = movie.poster_path {
            let _ = TMDBClient.sharedInstance().taskForGETImage(TMDBClient.PosterSizes.DetailPoster, filePath: posterPath, completionHandlerForImage: { (imageData, error) in
                if let image = UIImage(data: imageData!) {
                    performUIUpdatesOnMain {
                        self.endLoadingUI()
                        self.movieImageView.image = image
                    }
                }
            })
        } else {
            endLoadingUI()
        }

        updateUI()
 
    }
    
    @IBAction func addRemoveFavorite(_ sender: UIBarButtonItem) {
        let shouldFavorite = !isFavorite
        
        TMDBClient.sharedInstance().postToFavorites(movie!, favorite: shouldFavorite) { (success, error) in
            if let error = error {
                print(error)
            } else {
                if success ?? false {
                    self.isFavorite = shouldFavorite
                    performUIUpdatesOnMain {
                        self.updateUI()
                    }
                } else {
                    print("Failed to add to favorite movies.")
                }
            }
        }
    }
    
    @IBAction func addRemoveWatchlist(_ sender: UIBarButtonItem) {
        let shouldWatchlist = !isWatchlist
        
        TMDBClient.sharedInstance().postToWatchlist(movie!, watchlist: shouldWatchlist) { (success, error) in
            if let error = error {
                print(error)
            } else {
                if success ?? false {
                    self.isWatchlist = shouldWatchlist
                    performUIUpdatesOnMain {
                        self.updateUI()
                    }
                } else {
                    print("Failed to add to watchlist movies.")
                }
            }
        }
    }
    
    private func updateUI(){
        self.favoriteBtn.tintColor = self.isFavorite ? nil : .black
        self.watchlistBtn.tintColor = self.isWatchlist ? nil : .black
    }
}
