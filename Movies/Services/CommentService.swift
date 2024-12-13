//
//  CommentsService.swift
//  Movies
//
//  Created by Perejro on 09/12/2024.
//

import Foundation
import Alamofire

final class CommentService {
    static let baseURL = "https://jsonplaceholder.typicode.com/comments";

    func fetch(from url: URL, completion: @escaping(Result<[Comment], AFError>) -> Void) {
        AF.request(url)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let comments = Comment.fromServer(from: value)
                    completion(.success(comments))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func add(_ comment: CommentRequest, to url: URL, completion: @escaping(Result<Comment, AFError>) -> Void) {
        AF.request(
            url,
            method: .post,
            parameters: comment,
            encoder: JSONParameterEncoder(encoder: JSONEncoder())
        )
            .validate()
            .responseDecodable(of: Comment.self) { response in
                switch response.result {
                case .success(let comment):
                    completion(.success(comment))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
