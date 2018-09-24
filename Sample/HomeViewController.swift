//
//  HomeViewController.swift
//  Sample
//
//  Created by Théophane Rupin on 9/23/18.
//  Copyright © 2018 Scribd. All rights reserved.
//

import Foundation
import UIKit

final class MovieTableViewCell: UITableViewCell {
    
    struct ViewModel {
        let title: String
    }
    
    func bind(_ viewModel: ViewModel) {
        textLabel?.text = viewModel.title
    }
}

extension MovieTableViewCell.ViewModel {
    
    init(_ movie: Movie) {
        self.title = movie.title
    }
}

final class HomeViewController: UIViewController {
    
    private let dependencies: HomeViewControllerDependencyResolver
    
    private var movies = [Movie]()
    
    // weaver: movieManager = MovieManager
    
    // weaver: movieController = MovieViewController <- UIViewController
    // weaver: movieController.scope = .transient
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "\(MovieTableViewCell.self)")
        return tableView
    }()
    
    required init(injecting dependencies: HomeViewControllerDependencyResolver) {
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        edgesForExtendedLayout = []
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        dependencies.movieManager.getDiscoverMovies { page in
            guard let page = page else {
                return
            }
            self.movies = page.results
            self.tableView.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        let controller = dependencies.movieController(movie: movie)
        navigationController?.pushViewController(controller, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(MovieTableViewCell.self)", for: indexPath) as? MovieTableViewCell else {
            fatalError("Inconsitent data source")
        }
        
        let movie = movies[indexPath.row]
        let viewModel = MovieTableViewCell.ViewModel(movie)
        cell.bind(viewModel)
        
        return cell
    }
}
