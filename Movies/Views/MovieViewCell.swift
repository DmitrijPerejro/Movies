//
//  MovieCollectionCellViewViewController.swift
//  Movies
//
//  Created by Perejro on 30/11/2024.
//

import UIKit

final class MovieViewCell: UITableViewCell {
    // MARK: IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageViewPoster: UIImageView!
    
    let networkManager = NetworkManager.shared
    
    func configure(with movie: Movie) {
        titleLabel.text = "\(movie.fullTitle)\n\(movie.rating) ⭐"
        fetchMovieImage(from: movie.poster)
        imageViewPoster.layer.cornerRadius = imageViewPoster.frame.height / 2
    }
}

// MARK: - Network
private extension MovieViewCell {
    func fetchMovieImage(from url: String) {
        networkManager.fetchData(from: url, completion: {[unowned self] result in
            switch result {
            case .success(let image):
                imageViewPoster.image = UIImage(data: image)
            case .failure:
                imageView?.image = UIImage(named: "stub-movie-poster")
            }
        })
    }
}


