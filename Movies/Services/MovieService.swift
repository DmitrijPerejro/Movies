//
//  MoviesService.swift
//  Movies
//
//  Created by Perejro on 05/12/2024.
//

import Foundation
import Alamofire

final class MovieService {
    static let baseURL = "https://www.freetestapi.com/api/v1/movies";
    
    func fetchMovies(from url: URL, completion: @escaping(Result<[Movie], AFError>) -> Void) {
        AF.request(url)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let movies = Movie.fromServer(from: value)
                    completion(.success(movies))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
