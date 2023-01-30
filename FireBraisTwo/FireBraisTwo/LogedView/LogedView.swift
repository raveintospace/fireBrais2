//
//  LogedView.swift
//  FireBraisTwo
//
//  Created by Uri on 29/1/23.
//

import Foundation
import UIKit
import FirebaseAuth

enum ProviderType: String {
    case basic
    case google
}

final class LogedView: UIViewController {

    // MARK: - Properties
    var presenter: LogedPresenterProtocol?
    var delegate: LogoutProtocol!
    
    var safeArea: UILayoutGuide!
    let emailLabel = UILabel()
    let providerLabel = UILabel()
    let addressTextField = UITextField()
    let phoneTextField = UITextField()
    let logoutButton = UIButton()
    
    var provider: ProviderType?
    var email: String?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        view.backgroundColor = UIColor(red: 236/255, green: 239/255, blue: 241/255, alpha: 1)
    }
}

extension LogedView: LogedViewProtocol {
    
    // MARK: - View Layout
    func setupLogedView() {
        self.navigationItem.title = "Loged in view"
        self.navigationItem.setHidesBackButton(true, animated: false)
        safeArea = view.layoutMarginsGuide
        setupemailLabel()
        setupProviderLabel()
        setupAddressTextField()
        setupPhoneTextField()
        setupLogoutButton()
    }
    
    func setupemailLabel() {
        view.addSubview(emailLabel)
        
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10).isActive = true
        emailLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        emailLabel.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.75).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        emailLabel.layer.cornerRadius = 10
    }
    
    func setupProviderLabel() {
        view.addSubview(providerLabel)
        
        providerLabel.translatesAutoresizingMaskIntoConstraints = false
        providerLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 3).isActive = true
        providerLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        providerLabel.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.75).isActive = true
        providerLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true

        providerLabel.layer.cornerRadius = 10
    }
    
    func setupAddressTextField() {
        view.addSubview(addressTextField)
        
        addressTextField.translatesAutoresizingMaskIntoConstraints = false
        addressTextField.topAnchor.constraint(equalTo: providerLabel.bottomAnchor, constant: 3).isActive = true
        addressTextField.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        addressTextField.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.75).isActive = true
        addressTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
     
        addressTextField.configureLoginTextField()
        addressTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter your address",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        addressTextField.autocorrectionType = .no
    }
        
    func setupPhoneTextField() {
        
    }
    
    func setupLogoutButton() {
        view.addSubview(logoutButton)
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 6).isActive = true
        logoutButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        logoutButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.75).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        logoutButton.layer.cornerRadius = 10
        logoutButton.setTitle("Log out", for: .normal)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.backgroundColor = .orange
        
        logoutButton.addTarget(self, action: #selector(logoutButtonAction), for: .touchUpInside)
    }
    
    // MARK: - UIButton Actions
    
    @objc func logoutButtonAction() {
        
        switch provider {
        case .basic, .google:
            do {
                try Auth.auth().signOut()
                delegate.logoutButtonWasPressed()
                presenter?.goBackToHomeView() // ask homeinteractor to remove data
            } catch {
                print("An error happened with case basic")
            }
        case .none:
            print("case none")
        }
    }
    
    // MARK: - View data configuration
    
    func setDataInLogedVC(email: String, provider: ProviderType) {
        emailLabel.text = email
        providerLabel.text = provider.rawValue.capitalized
        self.provider = provider
        self.email = email
    }
}
