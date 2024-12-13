//
//  CommentsService.swift
//  Movies
//
//  Created by Perejro on 09/12/2024.
//

import Foundation

final class CommentService {
    private let networkManager = NetworkManager.shared

    func fetch(_ movieId: Int, completion: @escaping (Result<[Comment], NetworkError>) -> Void) {
        let url = "\(API.comments.rawValue)?postId=\(movieId)"
        
        guard let url = URL(string: url) else {
            completion(.failure(.noData))
            return
        }

        networkManager.fetch([Comment].self, from: url, completion: completion)
    }

}
