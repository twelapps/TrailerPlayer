//
//  ViewController.swift
//  TrailerPlayer
//
//  Created by H.F. Twelker on 12/04/2019.
//  Copyright © 2019 twelker. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class ViewController: UIViewController {

    @IBOutlet weak var MovieTableView: UITableView!
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var ErrorMessage: UILabel!
    
    let API_URL = "https://appstubs.triple-it.nl/trailers/"
    let SHORT_MOVIE_DESCRIPTION_LENGTH = 150
    let TRAILER_DOTS = "..."
    
    // String of Movie object to hold API results.
    // At any change, refresh the user interface.
//    var movies: [Movie] = [] {
    var fullMovies: [FullMovie] = [] {
        didSet {
            MovieTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Do not display error message field initially
        ErrorMessage.isHidden = true
        
        // Title on the table view controller in case a navigation controller is included.
        title = "Trailers"
        
        // Title text in large font.
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Necessary in order to navigate to the detail viewcontroller
        MovieTableView.delegate = self
        
        // Where can we find the source of the data to fill the tableview?
        MovieTableView.dataSource = self
        
        // Register the cell for use by the tableview.
        MovieTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        
        // Issue API request, default method is "get"
        Alamofire.request(API_URL)
            .responseData(completionHandler: { [weak self] (response) in
                // De-activate activity-indicator
                self?.ActivityIndicator.stopAnimating()
                
                if (response.error != nil) {
                    let logData = (response.error?.localizedDescription)!
                    print (logData)
                    self?.ErrorMessage.isHidden = false
                    self?.ErrorMessage.text = (response.error?.localizedDescription)!
                } else {
                    guard let jsonData = response.data else { return }
                    let decoder = JSONDecoder()
                    let movieObjectsFromBackend = try? decoder.decode([Movie].self, from: jsonData)
                
                    // Create an array of FullMovie objects from movies returned from API and add "favorite" indicator
                    for movie in movieObjectsFromBackend! {
                        self?.fullMovies.append(FullMovie(movie: movie))
                    }
//                    self?.movies = movieObjectsFromBackend!
                }
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Entered after pressing "Back" on the detail view
    override func viewDidAppear(_ animated: Bool) {
        MovieTableView.reloadData()
    }
}

extension ViewController:  UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MovieTableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        cell.MovieTitle.text = fullMovies[indexPath.row].movie.title
        
        // Display only a short movie description here
        let longMovieDescription = fullMovies[indexPath.row].movie.description
        if (longMovieDescription.endIndex.encodedOffset > SHORT_MOVIE_DESCRIPTION_LENGTH) {
            let stopIndex = longMovieDescription.index(longMovieDescription.startIndex, offsetBy: SHORT_MOVIE_DESCRIPTION_LENGTH)
            cell.MovieShortDescription.text = String(longMovieDescription[..<stopIndex]) + TRAILER_DOTS
        } else {
            cell.MovieShortDescription.text = longMovieDescription
        }
        
        
        let url = URL(string: fullMovies[indexPath.row].movie.posterImageUrl)
        cell.MovieThumbnailImageView.kf.setImage(with: url)
        //        cell.ImageFromGitHub.backgroundColor = .blue
        
        // Favorized?
        if (fullMovies[indexPath.row].favoriteMovie) {
            cell.MovieFavoriteSymbol.isHidden = false
        } else {
            cell.MovieFavoriteSymbol.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fullMovies.count
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let movieDetailVc = MovieDetailViewController(nibName: "MovieDetailViewController", bundle: nil)
        
        // Set the class property of the DetailViewController
        // Swift just passes a pointer to the object, so if the object is changed in the next viewcontroller and we return to this controller by pressing the "back" button we just have to reload the table data. Do this in func viewDidAppear.
        movieDetailVc.fullMovie = fullMovies[indexPath.row]
        
        self.navigationController?.pushViewController(movieDetailVc, animated: true)
    }
    
}

