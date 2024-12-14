//
//  Movie.swift
//  Movies
//
//  Created by Perejro on 28/11/2024.
//

struct Movie: Codable {
    let id: Int
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
    
    
    init(id: Int, title: String, year: Int, genre: [String], rating: Double, director: String, actors: [String], poster: String, description: String, duration: Int, website: String) {
        self.id = id
        self.title = title
        self.year = year
        self.genre = genre
        self.rating = rating
        self.director = director
        self.actors = actors
        self.poster = poster
        self.description = description
        self.duration = duration
        self.website = website
    }
    
    init(data: [String: Any]) {
        id = data["id"] as? Int ?? 0
        title = data["title"] as? String ?? ""
        year = data["year"] as? Int ?? 0
        genre = data["genre"] as? [String] ?? []
        rating = data["rating"] as? Double ?? 0
        director = data["director"] as? String ?? ""
        actors = data["actors"] as? [String] ?? []
        poster = data["poster"] as? String ?? ""
        description = data["plot"] as? String ?? ""
        duration = data["runtime"] as? Int ?? 0
        website = data["website"] as? String ?? ""
    }
    
    static func fromServer(from value: Any) -> [Movie] {
        guard let data = value as? [[String: Any]] else { return [] }
        return data.map { Movie(data: $0) }
    }
}
