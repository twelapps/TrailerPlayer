//
//  MovieDetailViewController.swift
//  TrailerPlayer
//
//  Created by H.F. Twelker on 12/04/2019.
//  Copyright © 2019 twelker. All rights reserved.
//

import UIKit
// The next two imports are needed for playing the movie trailer.
import AVFoundation
import AVKit

class MovieDetailViewController: UIViewController {
    
    let thumbUpImage: UIImage = UIImage(named: "Thumb_up")!
    let thumbDownImage: UIImage = UIImage(named: "Thumb_down")!
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var MovieLongDescription: UITextView!
    @IBOutlet weak var MovieGenre: UITextView!
    @IBOutlet weak var MoviePoster: UIImageView!
    @IBOutlet weak var MovieTrailer: UIButton!
    @IBOutlet weak var MovieThumbNail: UIImageView!
    @IBOutlet weak var FavoriteSymbol: UIImageView!
    @IBOutlet weak var FavOrUnfavButton: UIButton!
    
    // Class variable object, set by the calling ViewController
    var fullMovie: FullMovie?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Fill all the subviews of this view
        movieTitle.text = fullMovie?.movie.title
        MovieLongDescription.text = fullMovie?.movie.description
        for counter in 0...((fullMovie?.movie.genre.count)! - 1) { MovieGenre.text?.append((fullMovie?.movie.genre[counter])!)
            if (counter < ((fullMovie?.movie.genre.count)!)-1) {
                MovieGenre.text?.append("; ")
            }
        }

        var url = URL(string: (fullMovie?.movie.posterImageUrl)!)
        MovieThumbNail.kf.setImage(with: url)
        url = URL(string: (fullMovie?.movie.stillImageUrl)!)
        MoviePoster.kf.setImage(with: url)
        
        // Favorize functionality
        if (fullMovie?.favoriteMovie)! {
            FavoriteSymbol.isHidden = false
            FavOrUnfavButton.setImage(thumbDownImage, for: UIControlState.normal)
        } else {
            FavoriteSymbol.isHidden = true
            FavOrUnfavButton.setImage(thumbUpImage, for: UIControlState.normal)
        }
    }
    
    // OnCLick action for the play movietrailer button
    @IBAction func PlayTrailer(_ sender: Any) {let url = URL(string: (fullMovie?.movie.url)!)
        let player = AVPlayer(url: url!)
        let playerVC = AVPlayerViewController()
        playerVC .player = player
        
        present(playerVC, animated: true) {
            playerVC.player?.play()
        }
    }
    
    @IBAction func FavOrUnfavAction(_ sender: Any) {
        if (fullMovie?.favoriteMovie)! {
            fullMovie?.favoriteMovie = false
            FavoriteSymbol.isHidden = true
            FavOrUnfavButton.setImage(thumbUpImage, for: UIControlState.normal)
        } else {
            fullMovie?.favoriteMovie = true
            FavoriteSymbol.isHidden = false
            FavOrUnfavButton.setImage(thumbDownImage, for: UIControlState.normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Sharing trailer action
    @IBAction func SharingAction(_ sender: Any) {
        // https://www.hackingwithswift.com/example-code/uikit/how-to-share-content-with-uiactivityviewcontroller
        let textToShare = "This movie trailer is awesome!  Check it out! "
        
        if let myWebsite = NSURL(string: (fullMovie?.movie.url)!) {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = sender as? UIView
            self.present(activityVC, animated: true /*, completion: nil*/)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
