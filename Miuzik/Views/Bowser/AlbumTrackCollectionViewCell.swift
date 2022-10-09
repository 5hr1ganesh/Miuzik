//
//  AlbumTrackCollectionViewCell.swift
//  Miuzik
//
//  Created by Shriganesh Gupta on 09/10/22.
//

import Foundation
import UIKit

class AlbumTracksCollectionViewCell: UICollectionViewCell {
    static let identifier =  "AlbumTracksCollectionViewCell"
    
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
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        trackNameLabel.frame = CGRect(
            x: 10,
            y: 0,
            width: contentView.width-15,
            height: contentView.height/2)
        artistNameLabel.frame = CGRect(
            x: 10,
            y: contentView.height/2,
            width: contentView.width-15,
            height: contentView.height/2)
        }

    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        artistNameLabel.text = nil
    }

    func configure(with viewModel: AlbumCollectionViewCellVM) {
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
    }
}
