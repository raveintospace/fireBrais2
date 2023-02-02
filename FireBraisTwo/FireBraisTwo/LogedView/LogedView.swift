//
//  LogedView.swift
//  FireBraisTwo
//
//  Created by Uri on 29/1/23.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseRemoteConfig

enum ProviderType: String {
    case basic
    case google
}

final class LogedView: UIViewController {
    
    // MARK: - Properties
    var presenter: LogedPresenterProtocol?
    var delegate: LogoutProtocol!
    
    var safeArea: UILayoutGuide!
    let leftParagraphStyle = NSMutableParagraphStyle()
    let emailLabel = UILabel()
    let providerLabel = UILabel()
    let addressTextField = UITextField()
    let phoneTextField = UITextField()
    let saveButton = UIButton()
    let loadButton = UIButton()
    let deleteButton = UIButton()
    let logoutButton = UIButton()
    
    var provider: ProviderType?
    var email: String?
    
    private let db = Firestore.firestore()  // instance to connect with our database
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        view.backgroundColor = UIColor(red: 236/255, green: 239/255, blue: 241/255, alpha: 1)
        
        // Remote config with Firebase
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.fetchAndActivate { (status, error) in
            if status != .error {
                let showLogoutButton = remoteConfig.configValue(forKey: "show_logout_button").boolValue
                let logoutButtonText = remoteConfig.configValue(forKey: "logout_button_text").stringValue
                
                DispatchQueue.main.async {
                    self.logoutButton.isHidden = !showLogoutButton
                    self.logoutButton.setTitle(logoutButtonText, for: .normal)
                }
            }
        }
    }
}

extension LogedView: LogedViewProtocol {
    
    // MARK: - View Layout
    func setupLogedView() {
        self.navigationItem.title = "Loged in view"
        self.navigationItem.setHidesBackButton(true, animated: false)
        safeArea = view.layoutMarginsGuide
        leftParagraphStyle.alignment = .left
        setupemailLabel()
        setupProviderLabel()
        setupAddressTextField()
        setupPhoneTextField()
        setupSaveButton()
        setupLoadButton()
        setupDeleteButton()
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
     
        addressTextField.configureStandardUITextField()
        addressTextField.attributedPlaceholder = NSAttributedString(
            string: " Enter your address",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.paragraphStyle: leftParagraphStyle])
        addressTextField.textAlignment = .left
        addressTextField.autocorrectionType = .no
    }
        
    func setupPhoneTextField() {
        view.addSubview(phoneTextField)
        
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneTextField.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 3).isActive = true
        phoneTextField.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        phoneTextField.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.75).isActive = true
        phoneTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
     
        phoneTextField.configureStandardUITextField()
        phoneTextField.attributedPlaceholder = NSAttributedString(
            string: " Enter your phone number",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.paragraphStyle: leftParagraphStyle])
        phoneTextField.textAlignment = .left
        phoneTextField.autocorrectionType = .no
    }
    
    func setupSaveButton() {
        view.addSubview(saveButton)
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 6).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        saveButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.75).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        saveButton.configureStandardUIButton(title: "Save", backColor: .systemGreen)
        
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
    }
    
    func setupLoadButton() {
        view.addSubview(loadButton)
        
        loadButton.translatesAutoresizingMaskIntoConstraints = false
        loadButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 6).isActive = true
        loadButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        loadButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.75).isActive = true
        loadButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        loadButton.configureStandardUIButton(title: "Load", backColor: .systemGreen)
        
        loadButton.addTarget(self, action: #selector(loadButtonAction), for: .touchUpInside)
    }
    
    func setupDeleteButton() {
        view.addSubview(deleteButton)
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.topAnchor.constraint(equalTo: loadButton.bottomAnchor, constant: 6).isActive = true
        deleteButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        deleteButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.75).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        deleteButton.configureStandardUIButton(title: "Delete", backColor: .systemRed)
        
        deleteButton.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
    }
    
    func setupLogoutButton() {
        view.addSubview(logoutButton)
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.topAnchor.constraint(equalTo: deleteButton.bottomAnchor, constant: 18).isActive = true
        logoutButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        logoutButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.75).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        logoutButton.configureStandardUIButton(title: "Log out -no remote config-", backColor: .orange)
        
        logoutButton.addTarget(self, action: #selector(logoutButtonAction), for: .touchUpInside)
    }
    
    // MARK: - UIButton Actions
    
    @objc func saveButtonAction() {
        view.endEditing(true)           // edit not available when button is pushed
        
        if let email = email, let provider = provider {
            db.collection("users").document(email).setData([
                "provider":provider.rawValue,
                "address":addressTextField.text ?? "",
                "phone":phoneTextField.text ?? ""])
        }
    }
    
    @objc func loadButtonAction() {
        view.endEditing(true)
        
        db.collection("users").document(email ?? "").getDocument {
            (DocumentSnapshot, error) in
            
            if let document = DocumentSnapshot, error == nil {  // data has been recovered
                if let address = document.get("address") as? String {
                    self.addressTextField.text = address
                } else {
                    self.addressTextField.text = ""     // no address but there's a phone
                }
                if let phone = document.get("phone") as? String {
                    self.phoneTextField.text = phone
                } else {
                    self.phoneTextField.text = ""       // no phone but there's an address
                }
            } else {        // data hasn't been recovered
                self.addressTextField.text = ""
                self.phoneTextField.text = ""
            }
        }
    }
    
    @objc func deleteButtonAction() {
        view.endEditing(true)
        
        db.collection("users").document(email ?? "").delete()
    }
    
    @objc func logoutButtonAction() {
        
        switch provider {
        case .basic, .google:
            do {
                try Auth.auth().signOut()
                delegate.logoutButtonWasPressed()
                presenter?.goBackToHomeView()
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
