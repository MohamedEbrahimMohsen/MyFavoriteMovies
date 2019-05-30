//
//  WatchListTableViewController.swift
//  MyFavoriteMovies
//
//  Created by Mohamed Mohsen on 5/30/19.
//  Copyright © 2019 Mohamed Mohsen. All rights reserved.
//

import UIKit

class WatchListTableViewController: UITableViewController {

    var movies = [TMDBMovie]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem!.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(logout))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let group = DispatchGroup()
        group.enter()
        TMDBClient.sharedInstance().getWatchlistMovies { (movies, error) in
            guard error == nil else{
                self.display(error: "Failed to get the watched list movies.\(error!)")
                group.leave()
                return
            }
            self.movies = movies!
            group.leave()
        }
        group.wait()
        self.tableView.reloadData()
    }
    
    //MARK: Logout
    @objc func logout(){
        dismiss(animated: true, completion: nil)
    }
    
    func display(error: String){
        print(error)
    }
}


extension WatchListTableViewController{
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        
        let movie = movies[indexPath.row]
        
        guard movie.poster_path != nil else {
            print("Empty poster path.")
            return cell
        }
        
        guard movie.title != nil else {
            print("Empty movie title.")
            return cell
        }
        
        guard movie.vote_average != nil else {
            print("Empty vote average.")
            return cell
        }
        
        cell.textLabel?.text = movie.title
        cell.detailTextLabel?.text = String(movie.vote_average!)
        cell.imageView?.image = UIImage(named: "film")
        cell.imageView!.contentMode = .scaleAspectFit
        let group = DispatchGroup()
        group.enter()
        /* TASK: Get the poster image, then populate the image view */
        if let posterPath = movie.poster_path {
            let _ = TMDBClient.sharedInstance().taskForGETImage(TMDBClient.PosterSizes.RowPoster, filePath: posterPath) { (data, error) in
                guard error == nil else{
                    print("Error while getting the image.\(error!)")
                    group.leave()
                    return
                }
                
                guard let image = UIImage(data: data!) else{
                    print("Error while parsing the data to image.\(error!)")
                    group.leave()
                    return
                }
                performUIUpdatesOnMain {
                    cell.imageView?.image = image
                }
                group.leave()
            }
        }else{
            group.leave()
        }
        group.wait()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        if let movieDetailsVC = storyboard?.instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController{
            movieDetailsVC.movie = movie
            self.navigationController?.pushViewController(movieDetailsVC, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0
    }
}
