//
//  PlaylistheaderCollectionReusableView.swift
//  Miuzik
//
//  Created by Shriganesh Gupta on 09/10/22.
//

import SDWebImage
import UIKit

protocol PlaylistheaderCollectionReusableViewDelegate: AnyObject {
    func playlistheaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistheaderCollectionReusableView)
}

final class PlaylistheaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "PlaylistheaderCollectionReusableView"
    
    weak var delegate: PlaylistheaderCollectionReusableViewDelegate?
    
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
       let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let ownerLabel: UILabel = {
       let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    private let playAllButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemOrange
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        return button
    }()
    
    // init
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .systemOrange
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(ownerLabel)
        addSubview(playAllButton)
        playAllButton.addTarget(self, action: #selector(didTapPlayAll), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapPlayAll() {
//        button tap action
        delegate?.playlistheaderCollectionReusableViewDidTapPlayAll(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = height/1.9
        imageView.frame = CGRect(x: (width-imageSize)/2, y: 20, width: imageSize, height: imageSize)
        
        nameLabel.frame = CGRect(x: 10, y: imageView.bottom, width: width-20, height: 44)
        descriptionLabel.frame = CGRect(x: 10, y: nameLabel.bottom, width: width-20, height: 44)
        ownerLabel.frame = CGRect(x: 10, y: descriptionLabel.bottom, width: width-20, height: 30)
        
        playAllButton.frame = CGRect(x: width-75, y: height-75, width: 60, height: 60)
    }
    
    func configure(with viewModel: PlaylistHeaderVM) {
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
        ownerLabel.text = viewModel.ownerName
        imageView.sd_setImage(with: viewModel.artworkUrl, completed: nil)
    }
}
