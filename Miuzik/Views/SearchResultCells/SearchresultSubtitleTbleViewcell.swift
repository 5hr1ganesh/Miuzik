//
//  SearchresultSubtitleTbleViewcell.swift
//  Miuzik
//
//  Created by Shriganesh Gupta on 11/10/22.
//
import UIKit
import SDWebImage



class SearchresultSubtitleTbleViewcell: UITableViewCell {
    
    static let identifier = "SearchresultSubtitleTbleViewcell"
    
    private let label: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 1
        return label
    }()
    
    private let subtitlelabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(label)
        contentView.addSubview(subtitlelabel)
        contentView.addSubview(iconImageView)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height-10
        iconImageView.frame = CGRect(x: 10, y: 5, width: imageSize, height: imageSize)
        let labelHeight = contentView.height/2
        label.frame = CGRect(x: iconImageView.right+10, y: 0, width: contentView.width-iconImageView.right-15, height: labelHeight)
        
        subtitlelabel.frame = CGRect(x: iconImageView.right+10, y: labelHeight, width: contentView.width-iconImageView.right-15, height: labelHeight)
    
    }
    
        
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImageView.image = nil
        label.text = nil
        subtitlelabel.text = nil
    }
    
    
    func configure(with viewModel: SearchresultSubtitleTbleViewcellVM) {
        label.text = viewModel.title
        subtitlelabel.text = viewModel.subtitle
        iconImageView.sd_setImage(with: viewModel.imageURL, completed: nil)
    }
}

