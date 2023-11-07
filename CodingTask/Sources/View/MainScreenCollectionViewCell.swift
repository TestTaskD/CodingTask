//
//  MainScreenCollectionViewCell.swift
//  CodingTask
//
//  Created by Denis Aleshyn on 06/11/2023.
//

import UIKit
import Kingfisher

final class MainScreenCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topOffset),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingOffset),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.trailingOffset),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.bottomOffset)
        ])
        
        contentView.layer.cornerRadius = Constants.radius
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.borderWidth = Constants.borderWidth
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    func configureWith(_ imageURL: String) {
        imageView.kf.setImage(with: URL(string: imageURL))
    }
    
}

private extension MainScreenCollectionViewCell {
    enum Constants {
        static let bottomOffset: CGFloat = -30
        static let topOffset: CGFloat = 30
        static let leadingOffset: CGFloat = 30
        static let trailingOffset: CGFloat = -30
        
        static let borderWidth: CGFloat = 1
        static let radius: CGFloat = 20
    }
}
