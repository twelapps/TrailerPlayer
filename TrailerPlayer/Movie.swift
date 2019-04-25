//
//  Movie.swift
//  TrailerPlayer
//
//  Created by H.F. Twelker on 12/04/2019.
//  Copyright © 2019 twelker. All rights reserved.
//

import Foundation

struct Movie: Codable {
    let title: String
    let url: String
    let posterImageUrl: String
    let stillImageUrl: String
    let genre: [String]
    let description: String
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case url = "url"
        case posterImageUrl = "posterImage"
        case stillImageUrl = "stillImage"
        case genre = "genre"
        case description = "description"
    }
}
