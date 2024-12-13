//
//  CommentCollectionViewCell.swift
//  Movies
//
//  Created by Perejro on 09/12/2024.
//

import UIKit

class CommentViewCell: UICollectionViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var body: UILabel!
    
    func configure(with comment: Comment) {
        name.text = comment.author
        email.text = comment.email
        body.text = comment.body
    }
}
