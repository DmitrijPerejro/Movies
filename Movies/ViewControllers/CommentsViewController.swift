//
//  CommentViewController.swift
//  Movies
//
//  Created by Perejro on 09/12/2024.
//

import UIKit

class CommentsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    enum FethcingState {
        case loading
        case loaded
    }
    
    @IBOutlet weak var list: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var movieId: Int!
    
    var fetching = false {
        didSet {
            if fetching {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }

    private var comments: [Comment] = []
    private let commentsService = CommentService()

    
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
    
    func  collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            sizeForItemAt indexPath: IndexPath
        ) -> CGSize {
            let size = collectionView.frame.width - 32
            return CGSize(width: size, height: 200)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        list.dataSource = self
        list.delegate = self
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        
        fetchComments()
    }
    
    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.startAnimating()
    }
    
    
    private func fetchComments() {
        fetching = true
        
        commentsService.fetch(
            movieId,
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
