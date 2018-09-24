//
//  MovieViewController.swift
//  Sample
//
//  Created by Théophane Rupin on 9/24/18.
//  Copyright © 2018 Scribd. All rights reserved.
//

import Foundation
import UIKit

final class MovieViewController: UIViewController {
    
    private let dependencies: MovieViewControllerDependencyResolver
    
    // weaver: movie <= Movie
    
    // weaver: imageManager = ImageManager

    // weaver: reviewController = WSReviewViewController
    // weaver: reviewController.scope = .transient

    private var originalBarStyle: UIBarStyle?
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .natural
        return label
    }()
    
    private lazy var imageTapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImage(_:)))
        recognizer.numberOfTapsRequired = 1
        return recognizer
    }()
    
    required init(injecting dependencies: MovieViewControllerDependencyResolver) {
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        originalBarStyle = navigationController?.navigationBar.barStyle
        navigationController?.navigationBar.barStyle = .blackTranslucent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        originalBarStyle.flatMap { navigationController?.navigationBar.barStyle = $0 }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        edgesForExtendedLayout = []
        
        view.addSubview(thumbnailImageView)
        view.addSubview(overviewLabel)
        
        thumbnailImageView.addGestureRecognizer(imageTapGestureRecognizer)
        
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraintEqualToSystemSpacingBelow(view.topAnchor, multiplier: 2),
            thumbnailImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            thumbnailImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            
            overviewLabel.topAnchor.constraintEqualToSystemSpacingBelow(thumbnailImageView.bottomAnchor, multiplier: 2),
            overviewLabel.leadingAnchor.constraintEqualToSystemSpacingAfter(view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraintEqualToSystemSpacingAfter(overviewLabel.trailingAnchor, multiplier: 2),
            view.bottomAnchor.constraintGreaterThanOrEqualToSystemSpacingBelow(overviewLabel.bottomAnchor, multiplier: 2)
        ])
        
        title = dependencies.movie.title
        self.overviewLabel.text = dependencies.movie.overview
        
        self.dependencies.imageManager.getImage(with: dependencies.movie.poster_path) { image in
            guard let image = image else { return }
            self.thumbnailImageView.image = image
        }
    }
}

// MARK: - GestureRecognizer

private extension MovieViewController {
    
    @objc func didTapImage(_: UITapGestureRecognizer) {
        let controller = dependencies.reviewController(movieID: dependencies.movie.id)
        navigationController?.pushViewController(controller, animated: true)
    }
}
