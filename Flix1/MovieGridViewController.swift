//
//  MovieGridViewController.swift
//  Flix1
//
//  Created by Ethan Wong on 4/11/21.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies = [[String : Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        /* sizing stuff */
        // ----------------------------
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        /* controls space in between rows */
        layout.minimumLineSpacing = 5
        
        /* controls column spacing */
        layout.minimumInteritemSpacing = 5
        
        /* view.frame.size.width is a way to access width of this phone */
        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2) / 3
        
        /* configure layout of each item using dimensions / spacing */
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
        
        // ----------------------------
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
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
            
              /* since we updated the data we should reload what is displayed */
              self.collectionView.reloadData()
            
//              print(self.movies)

           }
        }
        task.resume()
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCollectionViewCell", for: indexPath) as! MovieGridCollectionViewCell
        
        /* unlike tableView, collectionView doesn't have a row / section --> it has an item */
        let movie = movies[indexPath.item]
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)!
        
        
        cell.posterView.af_setImage(withURL: posterUrl)
        
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
