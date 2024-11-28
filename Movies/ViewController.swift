//
//  ViewController.swift
//  Movies
//
//  Created by Perejro on 28/11/2024.
//

import UIKit

final class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovies()
    }
}

// MARK: - network flow
private extension ViewController {
    func fetchMovies() {
        let url = URL(string: "https://www.freetestapi.com/api/v1/movies")!
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "Error...")
                return
            }
            
            do {
                let movies = try JSONDecoder().decode([Movie].self, from: data)
                print(movies)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

