//
//  PlayViewController.swift
//  Spotify
//.
//

import UIKit
import SDWebImage

protocol PlayViewControllerDelegate: AnyObject {
    func didTapPlayPause()
    func didTapForward()
//    func didTapBackward()
    func didSlideSlider(_ value: Float)
}

class PlayViewController: UIViewController {

    weak var dataSource: PlayerDataSource?
    weak var delegate: PlayViewControllerDelegate?

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let controlsView = PlayControlsView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        controlsView.delegate = self
        configureBarButtons()
        configure()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.width)
        controlsView.frame = CGRect(
            x: 10,
            y: imageView.bottom+10,
            width: view.width-20,
            height: view.height-imageView.height-view.safeAreaInsets.top-view.safeAreaInsets.bottom-15
        )
    }

    private func configure() {
        imageView.sd_setImage(with: dataSource?.imageURL, completed: nil)
        controlsView.configure(
            with: PlayControlsViewViewModel(
                title: dataSource?.songName,
                subtitle: dataSource?.subtitle
            )
        )
    }

    private func configureBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapAction))
    }

    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func didTapAction() {
        // Actions
    }

    func refreshUI() {
        configure()
    }
}

extension PlayViewController: PlayControlsViewDelegate {
    func playControlsViewDidTapPlayPauseButton(_ playControlsView: PlayControlsView) {
        delegate?.didTapPlayPause()
    }

    func playControlsViewDidTapForwardButton(_ playControlsView: PlayControlsView) {
        delegate?.didTapForward()
    }

//    func playControlsViewDidTapBackwardsButton(_ playControlsView: PlayControlsView) {
//        delegate?.didTapBackward()
//    }

    func playControlsView(_ playControlsView: PlayControlsView, didSlideSlider value: Float) {
        delegate?.didSlideSlider(value)
    }
}
