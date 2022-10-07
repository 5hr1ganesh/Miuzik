//
//  WelcomeViewController.swift
//  Miuzik
//
//  Created by Shriganesh Gupta on 28/08/22.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let logINbutton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In with Miuzik", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Miuzik"
        view.backgroundColor = .systemOrange
        view.addSubview(logINbutton)
        logINbutton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
     
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logINbutton.frame  = CGRect(x: 20,
            y: view.height-50-view.safeAreaInsets.bottom,
            width: view.width-40,
            height: 50)
    }
    
    @objc func didTapSignIn(){
        let vc = LoginViewController()
        vc.completionHandler = {[weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIN(success: success)
            }
            
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    public func handleSignIN(success: Bool){
        guard success else {
            let alert = UIAlertController(title: "OOPS", message: "Somethung went wrong when signing in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        let mainAppTabBarVC = TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true)
    }
}
