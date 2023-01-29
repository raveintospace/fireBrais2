//
//  HomeInteractor.swift
//  FireBraisTwo
//
//  Created by Uri on 29/1/23.
//

import Foundation

final class HomeInteractor: HomeInteractorInputProtocol {
    
    // MARK: Properties
    var presenter: HomeInteractorOutputProtocol?
    var localDatamanager: HomeLocalDataManagerInputProtocol?
    var remoteDatamanager: HomeRemoteDataManagerInputProtocol?
    
    let defaults = UserDefaults.standard
    var email: String?
    var provider: ProviderType?
    
    func saveUserData(email: String, provider: ProviderType) {
        defaults.set(email, forKey: "email")
        defaults.set(provider.rawValue, forKey: "provider")
        defaults.synchronize()
        print("data saved")
        print(email)
        print(provider)
    }
    
    func removeUserData() {
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "provider")
        defaults.synchronize()
        print("data removed")
        print(email ?? "no data")
        print(provider ?? "empty")
    }
    
    func checkUserData() {
        if let email = UserDefaults.standard.string(forKey: "email"), let provider = UserDefaults.standard.string(forKey: "provider") {
            print(email)
            print(provider)
            presenter?.interactorPushDataToPresenter(email: email, provider: ProviderType(rawValue: provider) ?? .basic)
        } else {
            print("no data stored")
            presenter?.interactorNoDataToPresenter()
        }
        
    }
    
}

extension HomeInteractor: HomeRemoteDataManagerOutputProtocol {
    
}

// https://cocoacasts.com/ud-6-how-to-store-an-enum-in-user-defaults-in-swift
