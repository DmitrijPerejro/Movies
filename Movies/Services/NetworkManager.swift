//
//  NetworkManager.swift
//  Movies
//
//  Created by Perejro on 29/11/2024.
//

import Foundation

enum API: String {
    case movies = "https://www.freetestapi.com/api/v1/movies"
    case comments = "https://jsonplaceholder.typicode.com/comments"
}

enum NetworkError: Error {
    case noData
    case decode
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetch<T: Decodable>(
        _ type: T.Type,
        from url: URL,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
            
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decode))
                }
            }
        }.resume()
    }
    
    func fetchImage(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }
    
}
