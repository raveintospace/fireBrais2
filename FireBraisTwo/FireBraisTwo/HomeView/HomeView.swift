//
//  HomeView.swift
//  FireBraisTwo
//
//  Created by Uri on 29/1/23.
//

import Foundation
import UIKit
import FirebaseAnalytics
import FirebaseAuth
import GoogleSignIn
import FirebaseRemoteConfig

final class HomeView: UIViewController {
    
    // MARK: - Properties
    var presenter: HomePresenterProtocol?
    
    var safeArea: UILayoutGuide!
    let centeredParagraphStyle = NSMutableParagraphStyle()
    
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let signUpButton = UIButton()
    let logInButton = UIButton()
    let googleButton = UIButton()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        view.backgroundColor = UIColor(red: 236/255, green: 239/255, blue: 241/255, alpha: 1)
        
        // Analytics event
        Analytics.logEvent("InitScreen", parameters: ["message": "Firebase integration complete"])
        
        // Remote config with firebase
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 60          // 60 seconds, normally 12 hours
        
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(["show_logout_button":NSNumber(true),
                                  "logout_button_text":NSString("Log out -no remote config-")])
        
        // Check auth user's session
        presenter?.checkInteractorIfDataExists()
    }
}

// MARK: - Extensions

extension HomeView: HomeViewProtocol {
    
    // MARK: - View Layout
    func setupHomeView() {
        self.navigationItem.title = "Authentication"
        safeArea = view.layoutMarginsGuide
        centeredParagraphStyle.alignment = .center
        setupEmailTextField()
        setupPasswordTextField()
        setupSignUpButton()
        setupLogInButton()
        setupGoogleButton()
    }
    
    func setupEmailTextField() {
        view.addSubview(emailTextField)
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.75).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        emailTextField.configureStandardUITextField()
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter your email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
    }
    
    func setupPasswordTextField() {
        view.addSubview(passwordTextField)
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 3).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.75).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor).isActive = true
        
        passwordTextField.configureStandardUITextField()
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter your password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        passwordTextField.isSecureTextEntry = true
    }
    
    func setupSignUpButton() {
        view.addSubview(signUpButton)
        
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 6).isActive = true
        signUpButton.trailingAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: -1).isActive = true
        signUpButton.widthAnchor.constraint(equalTo: emailTextField.widthAnchor, multiplier: 0.49).isActive = true
        signUpButton.heightAnchor.constraint(equalTo: emailTextField.heightAnchor).isActive = true
        
        signUpButton.configureStandardUIButton(title: "Sign up", backColor: .blue)
        
        signUpButton.addTarget(self, action: #selector(signUpButtonAction), for: .touchUpInside)
    }
    
    func setupLogInButton() {
        view.addSubview(logInButton)
        
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 6).isActive = true
        logInButton.leadingAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 1).isActive = true
        logInButton.widthAnchor.constraint(equalTo: emailTextField.widthAnchor, multiplier: 0.49).isActive = true
        logInButton.heightAnchor.constraint(equalTo: emailTextField.heightAnchor).isActive = true
        
        logInButton.configureStandardUIButton(title: "Log in", backColor: .blue)
        
        logInButton.addTarget(self, action: #selector(logInButtonAction), for: .touchUpInside)
    }
    
    func setupGoogleButton() {
        view.addSubview(googleButton)
        
        googleButton.translatesAutoresizingMaskIntoConstraints = false
        googleButton.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 6).isActive = true
        googleButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        googleButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.75).isActive = true
        googleButton.heightAnchor.constraint(equalTo: emailTextField.heightAnchor).isActive = true
        
        googleButton.configureStandardUIButton(title: "Google", backColor: .white)
        googleButton.setImage(UIImage(named: "Google_icon"), for: .normal)
        googleButton.setTitleColor(.blue, for: .normal)
        
        googleButton.addTarget(self, action: #selector(googleButtonAction), for: .touchUpInside)
    }
    
    // MARK: - UIButtons Actions
    
    @objc func signUpButtonAction() {
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            Auth.auth().createUser(withEmail: email, password: password) {
                (result, error) in
                
                if let result = result, error == nil {  // user successfully created
                    self.presenter?.showLogedView(email: result.user.email!, provider: .basic)
                    self.presenter?.sendDataToInteractor(email: result.user.email!, provider: .basic)
                } else {    // error
                    let ac = UIAlertController(title: "Error", message: "Error creating the user", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func logInButtonAction() {
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            Auth.auth().signIn(withEmail: email, password: password) {
                (result, error) in
                
                if let result = result, error == nil {  // existing user successfully login
                    self.presenter?.showLogedView(email: result.user.email!, provider: .basic)
                    self.presenter?.sendDataToInteractor(email: result.user.email!, provider: .basic)
                } else {    // error
                    let ac = UIAlertController(title: "Error", message: "Error creating the user", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func googleButtonAction() {
        print("Google fato")
    }
    
    // MARK: - Load data from login and go to LogedView
    func presenterPushDataToView(email: String, provider: ProviderType) {
        print("data exists")
        presenter?.showLogedView(email: email, provider: provider)
    }
}

// MARK: - Extension for protocol

extension HomeView: LogoutProtocol {
    func logoutButtonWasPressed() {
        print("delegate is working")
        emailTextField.text = ""
        passwordTextField.text = ""
        presenter?.askInteractorToRemoveData()
    }
}


// MARK: - TO DO

// dark mode: navigation title black, detailview textcolor in black
// show password button - https://levelup.gitconnected.com/beginner-ios-dev-embed-a-secure-text-entry-toggle-button-into-a-uitextfield-17bacfc87608
