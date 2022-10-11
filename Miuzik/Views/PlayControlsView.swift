//
//  PlayControlsView.swift
//  Miuzik
//
//  Created by Shriganesh Gupta on 11/10/22.
//

import Foundation
import UIKit

protocol PlayControlsViewDelegate: AnyObject {
    func playControlsViewDidTapPlayPauseButton(_ playControlsView: PlayControlsView)
    func playControlsViewDidTapForwardButton(_ playControlsView: PlayControlsView)
//    func playControlsViewDidTapBackwardsButton(_ playControlsView: PlayControlsView)
    func playControlsView(_ playControlsView: PlayControlsView, didSlideSlider value: Float)
}

struct PlayControlsViewViewModel {
    let title: String?
    let subtitle: String?
}


final class PlayControlsView: UIView{
    private var isPlaying = true
    weak var delegate: PlayControlsViewDelegate?

    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        return slider
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "This Is My Song"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Eminem (feat. Some Other Artist)"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()

//    private let backButton: UIButton = {
//        let button = UIButton()
//        button.tintColor = .label
//        let image = UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
//        button.setImage(image, for: .normal)
//        return button
//    }()

    private let forwardButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()

    private let playPauseButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 44, weight: .bold))
        button.setImage(image, for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(nameLabel)
        addSubview(subtitleLabel)

        addSubview(volumeSlider)
            volumeSlider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)

//        addSubview(backButton)
        addSubview(forwardButton)
        addSubview(playPauseButton)

//        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(didTapForward), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)


        clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func didSlideSlider(_ slider: UISlider) {
           let value = slider.value
           delegate?.playControlsView(self, didSlideSlider: value)
       }

//       @objc private func didTapBack() {
//           delegate?.playControlsViewDidTapBackwardsButton(self)
//       }

       @objc private func didTapForward() {
           delegate?.playControlsViewDidTapForwardButton(self)
       }

       @objc private func didTapPlayPause() {
           self.isPlaying = !isPlaying
           delegate?.playControlsViewDidTapPlayPauseButton(self)

           // Update icon
           let pause = UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .bold))
           let play = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .bold))

           playPauseButton.setImage(isPlaying ? pause : play, for: .normal)
       }


    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.frame = CGRect(x: 0, y: 0, width: width, height: 50)
        subtitleLabel.frame = CGRect(x: 0, y: nameLabel.bottom+10, width: width, height: 50)

        volumeSlider.frame = CGRect(x: 10, y: subtitleLabel.bottom+20, width: width-20, height: 44)

        let buttonSize: CGFloat = 60
        playPauseButton.frame = CGRect(x: (width - buttonSize)/2, y: volumeSlider.bottom + 30, width: buttonSize, height: buttonSize)
//        backButton.frame = CGRect(x: playPauseButton.left-40-buttonSize, y: playPauseButton.top, width: buttonSize, height: buttonSize)
        forwardButton.frame = CGRect(x: playPauseButton.right+40, y: playPauseButton.top, width: buttonSize, height: buttonSize)
    }

    func configure(with viewModel: PlayControlsViewViewModel) {
            nameLabel.text = viewModel.title
            subtitleLabel.text = viewModel.subtitle
        }
}
