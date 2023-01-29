//
//  HomePresenter.swift
//  FireBraisTwo
//
//  Created by Uri on 29/1/23.
//

import Foundation

final class HomePresenter  {
    
    // MARK: Properties
    weak var view: HomeViewProtocol?
    var interactor: HomeInteractorInputProtocol?
    var wireFrame: HomeWireFrameProtocol?
    
}

extension HomePresenter: HomePresenterProtocol {
    func viewDidLoad() {
        view?.setupHomeView()
    }
    
    func showLogedView(email: String, provider: ProviderType) {
        wireFrame?.presentLogedView(from: view!, withEmail: email, withProvider: provider)
    }
    
    func sendDataToInteractor(email: String, provider: ProviderType) {
        interactor?.saveUserData(email: email, provider: provider)
    }
    
    func askInteractorToRemoveData() {
        interactor?.removeUserData()
    }
    
    func checkInteractorIfDataExists() {
        interactor?.checkUserData()
    }
}

extension HomePresenter: HomeInteractorOutputProtocol {
    func interactorPushDataToPresenter(email: String, provider: ProviderType) {
        view?.presenterPushDataToView(email: email, provider: provider)
    }
    
    func interactorNoDataToPresenter() {
        view?.setupHomeView()
    }
}
