//
//  ViewController.swift
//  nasa-apod
//
//  Created by Ladoo on 26/04/2022.
//  Copyright © 2022 Abhishek Kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        MiscellaneousViewFactory().prepareScrollView()
    }()
    
    private let scrollContentView: UIView = {
        MiscellaneousViewFactory().prepareView()
    }()
    
    private let imageView: UIImageView = {
        let view = MiscellaneousViewFactory().prepareImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let dateLabel: UILabel = {
        let view = MiscellaneousViewFactory().prepareLabel()
        view.textAlignment = .center
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = MiscellaneousViewFactory().prepareLabel()
        view.textAlignment = .center
        view.textColor = .systemBlue
        return view
    }()
    
    private let explanationLabel = {
        MiscellaneousViewFactory().prepareLabel()
    }()
    
    private let errorLabel = {
        MiscellaneousViewFactory().prepareLabel()
    }()
    
    enum StorageType {
        case userDefaults
    }
    
    private var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "APOD"
        view.backgroundColor = .white
        self.setupLayout()
        self.getAPOD()
    }
    
    private func getAPOD() {
        LoadingStart()
        viewModel.getNasaApod() { (isSuccess, error, cached) in
            self.LoadingStop {
                if isSuccess {
                    self.applyViewModel()
                } else if cached {
                      
                    let alert = MiscellaneousViewFactory().prepareAlertView(with: "Error", message: "We are not connected to the internet, showing you the last image we have.") { _ in
                        self.applyViewModel(in: true)
                    }
                    self.present(alert, animated: true)
                    
                } else {
                    self.showPageError()
                }
            }
        }
    }
    
    private func applyViewModel(in offlineMode: Bool = false) {
        
        self.dateLabel.text = self.viewModel.date
        self.titleLabel.text = self.viewModel.title
        self.explanationLabel.text = self.viewModel.explanation
        
        if offlineMode {
            self.imageView.image = self.viewModel.retrieveImage(forKey: "image")
        } else {
            self.loadImage(from: self.viewModel.url)
        }
    }
    
    private func loadImage(from imageUrl: String?) {
        viewModel.loadImage(from: imageUrl) { image in
            DispatchQueue.main.async() { [weak self] in
                self?.imageView.image = image
            }
        }
    }
    
    private func showPageError() {
        self.errorLabel.isHidden = false
        self.errorLabel.text = "Something went wrong!!"
    }
    
    private func setupLayout() {
        errorLabel.isHidden = true
        view.addSubview(errorLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        
        scrollContentView.addSubview(imageView)
        scrollContentView.addSubview(titleLabel)
        scrollContentView.addSubview(dateLabel)
        scrollContentView.addSubview(explanationLabel)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            dateLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            dateLabel.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -8),
            
            imageView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            
            explanationLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            explanationLabel.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            explanationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            explanationLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
