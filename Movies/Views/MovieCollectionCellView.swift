//
//  MovieCollectionCellViewViewController.swift
//  Movies
//
//  Created by Perejro on 30/11/2024.
//

import UIKit

final class MovieCollectionCellView: UICollectionViewCell {
    @IBOutlet weak var movieLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    
    private let networkManager = NetworkManager.shared
    
    func configure(with movie: Movie) {
        movieLabel.text = movie.fullTitle
        fetchMovieImage(from: URL(string: movie.poster)!)
    }
}

// MARK: - network flow
private extension MovieCollectionCellView {
    func fetchMovieImage(from url: URL) {
        networkManager.fetchImage(from: url, completion: {[unowned self] result in
            switch result {
            case .success(let image):
                movieImage.image = UIImage(data: image)
            case .failure:
                movieImage.image = UIImage(named: "stub-movie-poster")
            }
        })
    }
}
