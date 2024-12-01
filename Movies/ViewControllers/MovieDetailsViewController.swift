//
//  MovieDetailsViewController.swift
//  Movies
//
//  Created by Perejro on 30/11/2024.
//

import UIKit

final class MovieDetailsViewController: UIViewController {
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var raringLabel: UILabel!
    @IBOutlet weak var ratingStarsView: UIStackView!
    @IBOutlet var ratingStars: [UIImageView]!
    
    var movie: Movie!
    
    private let networkManager = NetworkManager.shared
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = movie.title
        setInitialInfo()
        fetchMovieImage(from: URL(string: movie.poster)!)
    }
    
    @IBAction func websiteButtonAction() {
        if let url = URL(string: movie.website) {
            UIApplication.shared.open(url)
        }
    }
    
    private func setInitialInfo() {
        descriptionLabel.text = movie.description
        durationLabel.text = converToHumanDuration(movie.duration)
        
        yearLabel.text = "\(movie.year)"
        directorLabel.text = movie.director
        actorsLabel.text = movie.actors.joined(separator: ", ")
        genresLabel.text = movie.genre.joined(separator: ", ")
        
        ratingStars.enumerated().forEach { (index, star) in
            let rating = Int(round(movie.rating))
            
            star.tintColor = .systemOrange
            star.image = UIImage(systemName: rating > index ? "star.fill" : "star")
        }
    }
    
    private func converToHumanDuration(_ duration: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .short
        
        let timeInterval = TimeInterval(duration * 60)
        
        return formatter.string(from: timeInterval) ?? "-"
    }
}

// MARK: - network flow
extension MovieDetailsViewController {
    func fetchMovieImage(from url: URL) {
        networkManager.fetchImage(from: url, completion: { [unowned self] result in
            switch result {
            case .success(let image):
                moviePoster.image = UIImage(data: image)
            case .failure:
                moviePoster.image = UIImage(named: "stub-movie-poster")
            }
        })
    }
}