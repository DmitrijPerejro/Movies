//
//  Comment.swift
//  Movies
//
//  Created by Perejro on 09/12/2024.
//

import Foundation

// stub
let userAvatar = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-Ybci_L25OcWJhFyrcmoR4q_vsqoAtT_Qug&s"

struct Comment: Decodable {
    let id: Int
    let author: String
    let email: String
    let body: String
    let avatar = userAvatar
    
    enum CodingKeys: String, CodingKey {
        case id
        case author = "name"
        case email
        case body
    }
}
