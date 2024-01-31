//
//  ListViewController.swift
//  LBCStore
//
//  Created by Volhan Salai on 30/01/2024.
//

import UIKit
import Combine

class ListViewController: UIViewController {
    // MARK: - Properties
    private var tableView: UITableView!
    var viewModel: ListViewModel!
    var coordinator: MainCoordinator?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(viewModel: ListViewModel, coordinator: MainCoordinator? = nil) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureTableView()
        bindViewModel()
        viewModel.loadData()
    }
    
    // MARK: - Setup UI
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // MARK: - Binding
    private func bindViewModel() {
        viewModel.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Navigation
    private func showDetail(for listing: Listing) {
        coordinator?.showListingDetailView(listing: listing)
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let listing = viewModel.items[indexPath.row]
        cell.textLabel?.text = listing.title
        // Additional cell configuration...
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listing = viewModel.items[indexPath.row]
        showDetail(for: listing)
    }
}
