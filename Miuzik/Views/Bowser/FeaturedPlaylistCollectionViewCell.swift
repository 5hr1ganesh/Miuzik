//
//  FeaturedPlaylistCollectionViewCell.swift
//  Miuzik
//
//  Created by Shriganesh Gupta on 27/09/22.
//

import UIKit

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeaturedPlaylistCollectionViewCell"
    
    
    public let playlistCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()

    public let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        label.textAlignment = .center
//        label.text = "Miuzik"
        return label
    }()


//    public let creatorNameLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 18, weight: .light)
//        label.numberOfLines = 0
//        label.textAlignment = .center
//        return label
//    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(playlistNameLabel)
//        contentView.addSubview(creatorNameLabel)
        contentView.clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
//        creatorNameLabel.frame = CGRect(x: 3, y: contentView.height-44, width: contentView.width-6, height: 30)
        playlistNameLabel.frame = CGRect(x: 3, y: contentView.height-60, width: contentView.width-6, height: 30)
        let imagesize = contentView.height-65
        playlistCoverImageView.frame = CGRect(x: (contentView.width-imagesize)/2, y: 3, width: imagesize, height: imagesize)
        }

    override func prepareForReuse() {
        super.prepareForReuse()
        playlistNameLabel.text = nil
//        creatorNameLabel.text = nil
//        numberOfTrackLabel.text = nil
        playlistCoverImageView.image = nil
    }

    func configure(with viewModel: FeaturedPlaylistCellVM) {
        playlistNameLabel.text = viewModel.name
//        creatorNameLabel.text = viewModel.creatorName
//        numberOfTrackLabel.text = "Tracks: \(viewModel.numberOfTracks)"
        playlistCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
}

