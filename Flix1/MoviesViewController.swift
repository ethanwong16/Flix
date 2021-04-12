//
//  MoviesViewController.swift
//  Flix1
//
//  Created by Ethan Wong on 4/4/21.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    /*  my note : variables you create here are called "properties"
            and are available to you for the lifetime of the screen
            
            - seems to be like "global" scope? */
    var movies = [[String : Any]]() // creates an array of dictionaries mapping Strings to Any

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        /* my note : this is run the first time that a screen is set up */
        
        /* these two are needed so that the tableView functions are called */
        tableView.dataSource = self
        tableView.delegate = self
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try!
                JSONSerialization.jsonObject(with: data, options: [])
                as! [String: Any]

//              print(dataDictionary)
            
              // TODO: Get the array of movies
              // TODO: Store the movies in a property to use elsewhere
              self.movies = dataDictionary["results"] as! [[String:Any]]
              
              // TODO: Reload your table view data
              /* this makes sure tableView functions are called after movies are loaded */
              self.tableView.reloadData()

           }
        }
        task.resume()
    }
    
    /* my note : these functions are not called continuously, have to tell table view to update
     whenever we want it to */
    
    /* this function asks you for the number of rows */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    /* gives you a cell for a particular row */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /* dequeueReusasbleCell lets you recycle cells that
         are off screen (otherwise create a new one if none) */
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell") as! MovieTableViewCell
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)!
        
        
        cell.posterView.af_setImage(withURL: posterUrl)
        
        return cell
        
    }

    
    // MARK: - Navigation
    
    /* my note: this is called when you're leaving a screen & want to prepare the next screen
        - usually called when you're sending data*/
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        /* note: the sender is the table view cell and tableView can determine which index path
         a particular cell is from */
        
        // Find the selected movie
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        
        // Pass the selected movie to the MovieDetailsViewController
        
        /* note: segue knows where it's going.  You need to cast to
         a MovieDetailsViewController specifically so that you can update
         it's movie property (basically passing it the movie info) */
        
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
        
        /* Make it so that when you click a cell and then go back to the
         movies list screen, it doesn't stay selected */
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}
