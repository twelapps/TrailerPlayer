//
//  MovieTableViewCell.swift
//  TrailerPlayer
//
//  Created by H.F. Twelker on 12/04/2019.
//  Copyright © 2019 twelker. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var MovieThumbnailImageView: UIImageView!
    @IBOutlet weak var MovieTitle: UILabel!
    @IBOutlet weak var MovieShortDescription: UITextView!
    @IBOutlet weak var MovieFavoriteSymbol: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Prepare cell for reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        // Clean cell
        MovieThumbnailImageView.image = nil
        MovieTitle.text = ""
        MovieShortDescription.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
