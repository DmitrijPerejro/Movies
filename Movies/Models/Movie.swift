//
//  Movie.swift
//  Movies
//
//  Created by Perejro on 28/11/2024.
//

struct Movie: Decodable {
    let title: String
    let year: Int
    let genre: [String]
    let rating: Double
    let director: String
    let actors: [String]
    let poster: String
    let description: String
    let duration: Int
    let website: String
    
    var fullTitle: String {
        "\(title) (\(year))"
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case year
        case genre
        case rating
        case director
        case actors
        case poster
        case description = "plot"
        case duration = "runtime"
        case website
    }
}
