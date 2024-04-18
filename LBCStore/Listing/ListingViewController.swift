//
//  ListingViewController.swift
//  LBCStore
//
//  Created by Volhan Salai on 13/04/2024.
//

import UIKit
import Combine

final class ListingViewController: UIViewController {
    private let viewModel: ListingViewModel
    private let coordinator: ListingCoordinator
    private var cancellables = Set<AnyCancellable>()
    
    private struct LayoutConstants {
        static let padding: CGFloat = 10
        
        static let fontSizeTitle: CGFloat = 20
        static let fontSizeNormal: CGFloat = 18
        static let fontSizeSubtitle: CGFloat = 16
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: LayoutConstants.fontSizeTitle)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: LayoutConstants.fontSizeNormal)
        label.textColor = .systemBlue
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: LayoutConstants.fontSizeSubtitle)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var urgentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: LayoutConstants.fontSizeNormal)
        label.textColor = .systemRed
        label.text = Strings.Listing.urgent
        return label
    }()
    
    init(viewModel: ListingViewModel, coordinator: ListingCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        coordinator.parentCoordinator?.removeChildCoordinator(coordinator)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureLayout()
        bindViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(urgentLabel)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: LayoutConstants.padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstants.padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LayoutConstants.padding),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: LayoutConstants.padding),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstants.padding),
            priceLabel.bottomAnchor.constraint(lessThanOrEqualTo: descriptionLabel.topAnchor, constant: -LayoutConstants.padding),
            
            urgentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: LayoutConstants.padding),
            urgentLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: LayoutConstants.padding),
            urgentLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -LayoutConstants.padding),
            urgentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LayoutConstants.padding),
            
            descriptionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: LayoutConstants.padding),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstants.padding),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LayoutConstants.padding),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -LayoutConstants.padding)
        ])
    }
    
    private func bindViewModel() {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        priceLabel.text = viewModel.price
        
        urgentLabel.isHidden = !viewModel.isUrgent
        
        if let imageUrl = viewModel.imageUrl {
            ImageLoader.loadImage(from: imageUrl)
                .replaceError(with: UIImage(named: Strings.Assets.placeholderImage))
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] image in
                    DispatchQueue.main.async {
                        self?.imageView.image = image ?? UIImage(named: Strings.Assets.placeholderImage)
                    }
                })
                .store(in: &cancellables)
        }
    }
}
