//
//  ListingTableViewCell.swift
//  LBCStore
//
//  Created by Volhan Salai on 04/02/2024.
//

import UIKit
import Combine

class ListingTableViewCell: UITableViewCell {
    static let identifier = "ListingTableViewCell"
    
    private let itemImageView = UIImageView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let priceLabel = UILabel()
    private let urgentLabel = UILabel()
    
    private var cancellables = Set<AnyCancellable>()
    
    private struct LayoutConstants {
        static let imageSize: CGFloat = 90
        static let padding: CGFloat = 10
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.image = nil
        titleLabel.text = nil
        dateLabel.text = nil
        priceLabel.text = nil
        urgentLabel.isHidden = true
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    private func setupViews() {
        itemImageView.contentMode = .scaleAspectFill
        itemImageView.clipsToBounds = true
        
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        urgentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(itemImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(urgentLabel)
        
        urgentLabel.textColor = .red
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            itemImageView.widthAnchor.constraint(equalToConstant: 90),
            itemImageView.heightAnchor.constraint(equalToConstant: 90),
            
            titleLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            dateLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            
            priceLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 10),
            priceLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
            priceLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            
            urgentLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 10),
            urgentLabel.topAnchor.constraint(equalTo: priceLabel.topAnchor, constant: 0),
            urgentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    func configure(with viewModel: ListingCellViewModel) {
        titleLabel.text = viewModel.title
        dateLabel.text = viewModel.date
        priceLabel.text = viewModel.price
        urgentLabel.text = Strings.Listing.urgent
        urgentLabel.isHidden = !viewModel.isUrgent
        
        itemImageView.image = UIImage(named: Strings.Assets.placeholderImage)
        
        guard let imageUrl = viewModel.imageUrl else { return }
        
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        ImageLoader.loadImage(from: imageUrl)
            .replaceError(with: UIImage(named: Strings.Assets.placeholderImage))
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] image in
                DispatchQueue.main.async {
                    self?.itemImageView.image = image ?? UIImage(named: Strings.Assets.placeholderImage)
                }
            })
            .store(in: &cancellables)
    }
}
