//
//  CommentViewController.swift
//  Movies
//
//  Created by Perejro on 09/12/2024.
//

import UIKit

protocol NewCommentViewControllerDelgate: AnyObject {
    func onSubmit(comment: Comment)
}

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController,
           let newReviewVC = navigationController.topViewController as? NewCommentViewController {
            newReviewVC.delegate = self
            newReviewVC.movie = movie
        }
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
            from: URL(string: "\(CommentService.baseURL)?postId=\(movie.id)")!,
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

// MARK: - NewCommentViewControllerDelgate
extension CommentsViewController: NewCommentViewControllerDelgate {
    func onSubmit(comment: Comment) {
        comments.append(comment)
        let newIndexPath = IndexPath(item: comments.count - 1, section: 0)
        list.insertItems(at: [newIndexPath])
        list.scrollToItem(at: newIndexPath, at: .bottom, animated: true)
    }
}
