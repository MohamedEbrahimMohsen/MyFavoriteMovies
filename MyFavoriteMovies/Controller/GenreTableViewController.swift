//
//  GenreTableViewController.swift
//  MyFavoriteMovies
//
//  Created by Mohamed Mohsen on 5/17/19.
//  Copyright © 2019 Mohamed Mohsen. All rights reserved.
//

import UIKit

class GenreTableViewController: UITableViewController {

    var appDelegate: AppDelegate!
    var movies = [TMDBMovie]()
    var genreID = 0
    
    //MARK: Logout
    @objc func logout(){
        dismiss(animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(logout))

/*
        // get the app delegate
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        // get the correct genre id
        genreID = genreIDFromItemTag(tableView.tag)

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(logout))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /*
        /* 1. Set the parameters */
        let methodParameters = [
            Constants.TMDB.ParameterKeys.ApiKey: Constants.TMDB.ParameterValues.ApiKey
        ]
        
        /* 2/3. Build the URL, Configure the request */
        let request = URLRequest(url: appDelegate.tmdbURLFromParameters(methodParameters as [String:AnyObject], withPathExtension: "/genre/\(genreID)/movies"))
        
        /* 4. Make the request */
        let task = appDelegate.sharedSession.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else{
                self.display(error: error as! String)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                self.display(error: "Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                self.display(error: "Data is corrupted")
                return
            }
            
            /* 5. Parse the data */
            let genreMovies: ResultsMovies?
            do{
                genreMovies = try JSONDecoder().decode(ResultsMovies.self, from: data)
                print("Genre Movies - Success")
            }catch let error{
                self.display(error: error as! String)
                return
            }
            
            /* GUARD: Success = true */
            guard genreMovies?.status_message == nil else {
                self.display(error: "Failed to decode the data correctly! \(String(describing: genreMovies?.status_message!))")
                return
            }
            
            /* 6. Use the data! */
            self.movies = (genreMovies?.results!)!
        }
        
        /* 7. Start the request */
        task.resume()
 */
    }
    
    //MARK: Logout
    @objc func logout(){
        dismiss(animated: true, completion: nil)
    }
    
    func display(error: String){
        print(error)
    }
}


extension GenreTableViewController{
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath)
        /*
        let movie = movies[indexPath.row]
        
        guard movie.poster_path != nil else {
            return cell
        }
        
        guard movie.title != nil else {
            return cell
        }
        
        guard movie.vote_average != nil else {
            return cell
        }
        
        cell.textLabel?.text = movie.title
        cell.detailTextLabel?.text = String(movie.vote_average!)
        cell.imageView?.image = #imageLiteral(resourceName: "4k-wallpaper-blur-close-up-1152707")
        cell.imageView!.contentMode = .scaleAspectFit
        
        /* TASK: Get the poster image, then populate the image view */
        if let posterPath = movie.poster_path {
            
            /* 1. Set the parameters */
            // There are none...
            
            /* 2. Build the URL */
            let baseURL = URL(string: appDelegate.config.baseImageURLString)!
            let url = baseURL.appendingPathComponent("w154").appendingPathComponent(posterPath)
            
            /* 3. Configure the request */
            let request = URLRequest(url: url)
            
            /* 4. Make the request */
            let task = appDelegate.sharedSession.dataTask(with: request) { (data, response, error) in
                
                /* GUARD: Was there an error? */
                guard (error == nil) else {
                    print("There was an error with your request: \(error!)")
                    return
                }
                
                /* GUARD: Did we get a successful 2XX response? */
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                    print("Your request returned a status code other than 2xx!")
                    return
                }
                
                /* GUARD: Was there any data returned? */
                guard let data = data else {
                    print("No data was returned by the request!")
                    return
                }
                
                /* 5. Parse the data */
                // No need, the data is already raw image data.
                
                /* 6. Use the data! */
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.imageView!.image = image
                    }
                } else {
                    print("Could not create image from \(data)")
                }
            }
            
            /* 7. Start the request */
            task.resume()
        }
        */
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        if let movieDetailsVC = storyboard?.instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController{
            movieDetailsVC.movie = movie
            self.navigationController?.pushViewController(movieDetailsVC, animated: true)
        }
    }
}


// MARK: - GenreTableViewController (Genre Map)

private extension GenreTableViewController {
    
    func genreIDFromItemTag(_ itemTag: Int) -> Int {
        
        let genres: [String] = [
            "Sci-Fi",
            "Comedy",
            "Action"
        ]
        
        let genreMap: [String:Int] = [
            "Action": 28,
            "Sci-Fi": 878,
            "Comedy": 35
        ]
        
        return genreMap[genres[itemTag]]!*/
    }
}
