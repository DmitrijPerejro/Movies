//
//  MoviesService.swift
//  Movies
//
//  Created by Perejro on 05/12/2024.
//

import Foundation

final class MovieService {
    private let networkManager = NetworkManager.shared

    func fetchMovies(completion: @escaping (Result<[Movie], NetworkError>) -> Void) {
        guard let url = URL(string: API.movies.rawValue) else {
            completion(.failure(.noData))
            return
        }

        networkManager.fetch([Movie].self, from: url, completion: completion)
    }

}
