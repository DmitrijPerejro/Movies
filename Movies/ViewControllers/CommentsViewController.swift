//
//  CommentViewController.swift
//  Movies
//
//  Created by Perejro on 09/12/2024.
//

import UIKit

final class CommentsViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet weak var list: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - data
    var movie: Movie!
    private var comments: [Comment] = []
    
    private var fetching = false {
        didSet {
            fetching ?
                activityIndicator.startAnimating() :
                activityIndicator.stopAnimating()
        }
    }

    // MARK: - services
    private let commentsService = CommentService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        list.dataSource = self
        list.delegate = self
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        
        fetchComments()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CommentsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let size = collectionView.frame.width - 32
        return CGSize(width: size, height: 200)
    }
}

// MARK: - UICollectionViewDataSource
extension CommentsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "commentCell", for: indexPath)
        
        guard let cell = cell as? CommentViewCell else {
            return UICollectionViewCell()
        }
        
        let comment = comments[indexPath.item]
        cell.configure(with: comment)
        
        return cell
    }
}

// MARK: - Network
extension CommentsViewController {
    private func fetchComments() {
        fetching = true
        
        commentsService.fetch(
            movie.id,
            completion: { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success(let comments):
                    self.comments = comments
                    fetching = false
                    self.list.reloadData()
                    
                case .failure(_):
                    self.comments.removeAll()
                    fetching = false
                    self.list.reloadData()
                }
            }
        )
    }
}
