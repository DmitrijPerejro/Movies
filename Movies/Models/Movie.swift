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
}
