//
//  CommentCollectionViewCell.swift
//  Movies
//
//  Created by Perejro on 09/12/2024.
//

import UIKit

final class CommentViewCell: UICollectionViewCell {
    // MARK: IBOutlets
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var body: UILabel!
    
    private let networkManager = NetworkManager.shared
    
    func configure(with comment: Comment) {
        name.text = comment.author
        email.text = comment.email
        body.text = comment.body
        
        fetchMovieImage(from: URL(string: comment.avatar)!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        
    }

    private func setupUI() {
        avatar.layer.cornerRadius = avatar.frame.width / 2
        avatar.layer.masksToBounds = true

        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .white

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4
        layer.masksToBounds = false
    }
}

// MARK: - Network
private extension CommentViewCell {
    func fetchMovieImage(from url: URL) {
        networkManager.fetchImage(from: url, completion: { [unowned self] result in
            switch result {
            case .success(let image):
                avatar.image = UIImage(data: image)
            case .failure:
                avatar.image = UIImage(named: "stub-movie-poster")
            }
        })
    }
}
