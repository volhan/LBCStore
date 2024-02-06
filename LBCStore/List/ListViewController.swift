//
//  ListViewController.swift
//  LBCStore
//
//  Created by Volhan Salai on 30/01/2024.
//

import UIKit
import Combine

class ListViewController: UIViewController {
    private var tableView: UITableView!
    var viewModel: ListViewModel!
    var coordinator: MainCoordinator?
    private var cancellables = Set<AnyCancellable>()
    
    private struct Constants {
        static let rowHeight: CGFloat = 120
    }
    
    init(viewModel: ListViewModel, coordinator: MainCoordinator? = nil) {
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
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListingTableViewCell.self, forCellReuseIdentifier: ListingTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Constants.rowHeight
    }
    
    private func bindViewModel() {
        viewModel.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
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
        let cellViewModel = ListingCellViewModel(listing: listing)
        cell.configure(with: cellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let listing = viewModel.items[indexPath.row]
        showDetail(for: listing)
    }
    
    private func showDetail(for listing: Listing) {
        coordinator?.showListingDetailView(listing: listing)
    }
}
