//
//  Comment.swift
//  Movies
//
//  Created by Perejro on 09/12/2024.
//

import Foundation

struct Comment: Codable {
    let id: Int
    let author: String
    let email: String
    let body: String
    let avatar: String?
    
    init(id: Int, author: String, email: String, body: String, avatar: String?) {
        self.id = id
        self.author = author
        self.email = email
        self.body = body
        self.avatar = avatar
    }
    
    init(data: [String: Any]) {
        id = data["id"] as? Int ?? 0
        author = data["name"] as? String ?? ""
        email = data["email"] as? String ?? ""
        body = data["body"] as? String ?? ""
        avatar = data["avatar"] as? String ?? nil
    }

    static func fromServer(from value: Any) -> [Comment] {
        guard let data = value as? [[String: Any]] else { return [] }
        return data.map { Comment(data: $0) }
    }
}

struct CommentRequest: Encodable {
    let author: String
    let email: String
    let body: String
}
