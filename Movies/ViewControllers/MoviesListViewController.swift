//
//  MoviesCollectionViewController.swift
//  Movies
//
//  Created by Perejro on 29/11/2024.
//

import UIKit

final class MoviesListViewController: UIViewController, UITextFieldDelegate {
    enum Order: String {
        case asc, desc
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var listView: UICollectionView!
    @IBOutlet weak var searchView: UIStackView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emptyResultLabel: UILabel!
    
    // MARK: - controls
    @IBOutlet weak var limitControl: UISegmentedControl!
    @IBOutlet weak var sortControl: UISegmentedControl!
    
    // MARK: - data
    private var movies: [Movie] = []
    
    //MARK: - navigation identifier
    private let navigationIdentifier = "movieDetails"
    
    // MARK: - initial earch params
    let initialLimit = 20
    let initialOrder: Order = .asc

    // MARK: - search params
    private lazy var limit = initialLimit
    private lazy var order: Order = initialOrder
    
    // MARK: - network
    private let networkManager = NetworkManager.shared
    
    // MARK: - controls values
    private let limitControlValues = [5, 10, 15, 20]
    private let sortControlValues = [Order.asc, Order.desc]

    private var fetching = false {
        didSet {
            if fetching {
                listView.isHidden = true
                emptyResultLabel.isHidden = true
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
                
                if movies.isEmpty {
                    emptyResultLabel.isHidden = false
                } else {
                    listView.isHidden = false
                }
            }
        }
    }
            
    override func viewDidLoad() {
        super.viewDidLoad()

        listView.delegate = self
        listView.dataSource = self
        searchTextField.delegate = self
        
        searchView.isHidden = true
        emptyResultLabel.isHidden = true
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
        
        initLimitControl()
        initSortControl()
        
        fetchMovies()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
        
    @IBAction func navigationSearchAction(_ sender: UIBarButtonItem) {
        searchView.isHidden.toggle()
        
        if searchView.isHidden {
            sender.image = UIImage(systemName: "magnifyingglass")
            searchTextField.resignFirstResponder()
        } else {
            sender.image = UIImage(systemName: "xmark")
            self.searchTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func resetButtonAction() {
        searchTextField.text = ""
        limit = initialLimit
        order = initialOrder
    
        limitControl.selectedSegmentIndex = 3
        sortControl.selectedSegmentIndex = 0
        fetchMovies()
    }
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        fetchMovies()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        fetchMovies()
        view.endEditing(true)
        return true
    }
    
    private func initLimitControl() {
        limitControl.removeAllSegments()
        limitControlValues.enumerated().forEach { (index, limit) in
            limitControl.insertSegment(withTitle: "\(limit)", at: index, animated: false)
        }
        limitControl.selectedSegmentIndex = 3
    }
    
    private func initSortControl() {
        sortControl.removeAllSegments()
        sortControlValues.enumerated().forEach { (index, order) in
            sortControl.insertSegment(withTitle: "\(order.rawValue)", at: index, animated: false)
        }
        sortControl.selectedSegmentIndex = 0
    }
    
    private func loading(is state: Bool) {
        fetching = state
    }
}

// MARK: - Navigation
extension MoviesListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == navigationIdentifier {
            if let detailsVC = segue.destination as? MovieDetailsViewController {
                if let movie = sender as? Movie {
                    detailsVC.movie = movie
                }
            }
        }
    }
    
    func onSelectMovie(_ movie: Movie) {
        performSegue(withIdentifier: navigationIdentifier, sender: movie)
    }
}

// MARK: - UICollectionViewDataSource
extension MoviesListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath)
        guard let cell = cell as? MovieCollectionCellView else {
            return UICollectionViewCell()
        }
        
        let movie = movies[indexPath.item]
        cell.configure(with: movie)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MoviesListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        onSelectMovie(movie)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension MoviesListViewController: UICollectionViewDelegateFlowLayout {
    func  collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let size = collectionView.frame.width - 40
        return CGSize(width: size, height: size)
    }
}

// MARK: - networkManager flow
private extension MoviesListViewController {
    func prepareURL() -> String {
        var url = "https://www.freetestapi.com/api/v1/movies"
        let searchText = searchTextField.text ?? ""
        let limit = (limitControl.selectedSegmentIndex + 1) * 5
        let order = sortControl.selectedSegmentIndex == 0 ? Order.asc : .desc
        
        var isFirstParam = true

        if !searchText.isEmpty {
            url += "?search=\(searchText)"
            isFirstParam = false
        }

        url += "\(isFirstParam ? "?" : "&")limit=\(limit)&sort=name&order=\(order)"
     
        return url
    }
    
    func fetchMovies() {
        loading(is: true)
        let url = prepareURL()
        
        networkManager.fetch(
            [Movie].self,
            from: URL(string: url)!
        ) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let movies):
                self.movies = movies
                loading(is: false)
                listView.reloadData()
            case .failure(let error):
                self.movies.removeAll()
                loading(is: false)
                emptyResultLabel.text = error.localizedDescription
            }
        }
    }
}
