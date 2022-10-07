//
//  RecommendedTracksCollectionViewCell.swift
//  Miuzik
//
//  Created by Shriganesh Gupta on 27/09/22.
//

import UIKit

class RecommendedTracksCollectionViewCell: UICollectionViewCell {
    static let identifier =  "RecommendedTracksCollectionViewCell"
    
    public let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        
        return imageView
    }()

    public let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
//        label.textAlignment = .center
//        label.text = "Miuzik"
        return label
    }()


    public let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.numberOfLines = 0
//        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        albumCoverImageView.frame = CGRect(x: 5, y: 2, width: contentView.height-4, height: contentView.height-4)
        trackNameLabel.frame = CGRect(x: albumCoverImageView.right+10, y: 0,
                                      width: contentView.width-albumCoverImageView.right-15,
                                      height: contentView.height/2)
        artistNameLabel.frame = CGRect(x: albumCoverImageView.right+10,
                                       y: contentView.height/2,
                                      width: contentView.width-albumCoverImageView.right-15,
                                      height: contentView.height/2)
        }

    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        artistNameLabel.text = nil
//        numberOfTrackLabel.text = nil
        albumCoverImageView.image = nil
    }

    func configure(with viewModel: RecommendedTrackCellVM) {
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
//        numberOfTrackLabel.text = "Tracks: \(viewModel.numberOfTracks)"
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
}



