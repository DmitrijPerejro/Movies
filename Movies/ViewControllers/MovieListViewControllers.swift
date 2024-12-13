//
//  MovieListViewControllersTableViewController.swift
//  Movies
//
//  Created by Perejro on 13/12/2024.
//

import UIKit

final class MovieListViewControllers: UITableViewController {
    // MARK: services
    private let moviesService = MovieService()
    private let search = UISearchController(searchResultsController: nil)
    
    // MARK: - data
    private var movies: [Movie] = []
    private var filteredMovies: [Movie] = []
    private var data: [Movie] {
        let result = (search.searchBar.text ?? "").isEmpty ? movies : filteredMovies
        return result.sorted { $0.rating > $1.rating }
    }

    private var isSearching: Bool {
        search.isActive && !(search.searchBar.text ?? "").isEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = setupUISearchController()
        fetchMovies()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
        let movie = data[indexPath.row]
        
        if let detailsVC = segue.destination as? MovieDetailsViewController {
            detailsVC.movie = movie
        }
    }
    
    private func setupUISearchController() -> UISearchController {
        search.searchResultsUpdater = self

        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search"
        definesPresentationContext = true
        
        return search
    }
    
}

// MARK: - UICollectionViewDataSource
extension MovieListViewControllers {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieViewCell else {
            return UITableViewCell()
        }

        let movie = data[indexPath.item]
        cell.configure(with: movie)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if (!isSearching) {
            return nil
        }
        
        if (isSearching && data.count == 0) {
            return "Фильмов не найдено"
        }
        
        return "Найдено \(data.count)"
    }
}

// MARK: - UISearchResultsUpdating
extension MovieListViewControllers: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredMovies = movies.filter { movie in
            movie.title.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
}

// MARK: - Network
extension MovieListViewControllers {
    private func fetchMovies() {
        moviesService.fetchMovies(
            from: URL(string: MovieService.baseURL)!,
            completion: { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success(let movies):
                    self.movies = movies
                    self.tableView.reloadData()
                case .failure(_):
                    self.movies.removeAll()
                }
            }
        )
    }
}
