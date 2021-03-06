//
//  SearchViewController.swift
//  MyFavoriteMovies
//
//  Created by Mohamed Mohsen on 5/30/19.
//  Copyright © 2019 Mohamed Mohsen. All rights reserved.
//

import UIKit

// MARK: - SearchViewControllerDelegate

protocol MoviePickerViewControllerDelegate {
    func moviePicker(_ moviePicker: SearchViewController, didPickMovie movie: TMDBMovie?)
}

class SearchViewController: UIViewController {

    // MARK: Properties

    // the data for the table
    var movies = [TMDBMovie]()
    
    // the delegate will typically be a view controller, waiting for the Movie Picker to return an movie
    var delegate: MoviePickerViewControllerDelegate?
    
    // the most recent data download task. We keep a reference to it so that it can be canceled every time the search text changes
    var searchTask: URLSessionDataTask?
    
    // MARK: Outlets

    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var movieTableView: UITableView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.topItem!.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(logout))

        // configure tap recognizer
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.delegate = self
        view.addGestureRecognizer(tapRecognizer)
        
        self.movieTableView.delegate = self
        self.movieTableView.dataSource = self
        self.movieSearchBar.delegate = self
    }
    
    // MARK: Dismissals
    
    @objc func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    private func cancel() {
        delegate?.moviePicker(self, didPickMovie: nil)
        logout()
    }
    
    @objc func logout() {
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - SearchViewController: UIGestureRecognizerDelegate

extension SearchViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        //hide the keyboard by touch any (not keyboard) point on the screen
        return movieSearchBar.isFirstResponder
    }
}

// MARK: - SearchViewController: UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    // each time the search text changes we want to cancel any current download and start a new one
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // cancel the last task
        if let task = searchTask {
            task.cancel()
        }
        
        // if the text is empty we are done
        if searchText == "" {
            movies = [TMDBMovie]()
            movieTableView?.reloadData()
            return
        }
        
        // new search
        searchTask = TMDBClient.sharedInstance().getMoviesForSearchString(searchText) { (movies, error) in
            self.searchTask = nil
            if let movies = movies {
                self.movies = movies
                performUIUpdatesOnMain {
                    self.movieTableView!.reloadData()
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}


// MARK: - SearchViewController: UITableViewDelegate, UITableViewDataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CellReuseId = "MovieSearchCell"
        let movie = movies[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseId) as UITableViewCell?
        
        if let releaseYear = movie.release_date {
            cell?.textLabel!.text = "\(movie.title!) (\(releaseYear))"
        } else {
            cell?.textLabel!.text = "\(movie.title!)"
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[(indexPath as NSIndexPath).row]
        let controller = storyboard!.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
        controller.movie = movie
        navigationController!.pushViewController(controller, animated: true)
    }
}
