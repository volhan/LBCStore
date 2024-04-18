//
//  ListViewController.swift
//  LBCStore
//
//  Created by Volhan Salai on 13/04/2024.
//

import UIKit
import Combine

final class ListViewController: UIViewController {
    private let viewModel: ListViewModel
    private let coordinator: MainCoordinator
    private var cancellables = Set<AnyCancellable>()
    
    private struct LayoutConstants {
        static let rowHeight: CGFloat = 90
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListingTableViewCell.self, forCellReuseIdentifier: ListingTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var filterBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = Strings.Filter.filterTitle
        button.target = self
        button.action = #selector(filterButtonTapped)
        return button
    }()
    
    init(viewModel: ListViewModel, coordinator: MainCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureTableView()
        bindViewModel()
        viewModel.loadData()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
        
        self.navigationItem.rightBarButtonItem = filterBarButtonItem
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListingTableViewCell.self, forCellReuseIdentifier: ListingTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = LayoutConstants.rowHeight
    }
    
    private func bindViewModel() {
        viewModel.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @objc private func filterButtonTapped() {
        let alertController = UIAlertController(title: Strings.Filter.filterAlertTitle, message: nil, preferredStyle: .actionSheet)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = filterBarButtonItem
        }
        
        viewModel.categories.forEach { category in
            alertController.addAction(UIAlertAction(title: category.name, style: .default, handler: { _ in
                self.viewModel.filterItems(by: category)
            }))
        }
        
        alertController.addAction(UIAlertAction(title: Strings.Filter.clear, style: .destructive, handler: { _ in
            self.viewModel.clearFilter()
        }))
        
        alertController.addAction(UIAlertAction(title: Strings.Buttons.cancel, style: .cancel))
        present(alertController, animated: true)
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListingTableViewCell.identifier, for: indexPath) as? ListingTableViewCell else {
            return UITableViewCell()
        }
        let listing = viewModel.items[indexPath.row]
        let cellViewModel = ListingCellViewModel(listing: listing, categories: viewModel.categories)
        cell.configure(with: cellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let listing = viewModel.items[indexPath.row]
        showDetail(for: listing)
    }
    
    private func showDetail(for listing: Listing) {
        coordinator.showListingDetailView(listing: listing)
    }
}
