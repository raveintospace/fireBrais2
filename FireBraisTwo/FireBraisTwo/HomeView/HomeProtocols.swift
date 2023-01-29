//
//  HomeProtocols.swift
//  FireBraisTwo
//
//  Created by Uri on 29/1/23.
//

import Foundation
import UIKit

protocol HomeViewProtocol: AnyObject {
    // PRESENTER -> VIEW
    var presenter: HomePresenterProtocol? { get set }
    func setupHomeView()
    func presenterPushDataToView(email: String, provider: ProviderType)
}

protocol HomeWireFrameProtocol {
    // PRESENTER -> WIREFRAME
    static func createHomeModule() -> UINavigationController
    
    func presentLogedView(from view: HomeViewProtocol, withEmail: String, withProvider: ProviderType)
}

protocol HomePresenterProtocol: AnyObject {
    // VIEW -> PRESENTER
    var view: HomeViewProtocol? { get set }
    var interactor: HomeInteractorInputProtocol? { get set }
    var wireFrame: HomeWireFrameProtocol? { get set }
    
    func viewDidLoad()
    func showLogedView(email: String, provider: ProviderType)
    func sendDataToInteractor(email: String, provider: ProviderType)
    func askInteractorToRemoveData()
    func checkInteractorIfDataExists()
}

protocol HomeInteractorOutputProtocol {
    // INTERACTOR -> PRESENTER
    func interactorPushDataToPresenter(email: String, provider: ProviderType)
    func interactorNoDataToPresenter()
}

protocol HomeInteractorInputProtocol: AnyObject {
    // PRESENTER -> INTERACTOR
    var presenter: HomeInteractorOutputProtocol? { get set }
    var localDatamanager: HomeLocalDataManagerInputProtocol? { get set }
    var remoteDatamanager: HomeRemoteDataManagerInputProtocol? { get set }
    
    var email: String? { get set }
    var provider: ProviderType? { get set }
    
    func saveUserData(email: String, provider: ProviderType)
    func removeUserData()
    func checkUserData()
}

protocol HomeDataManagerInputProtocol {
    // INTERACTOR -> DATAMANAGER
}

protocol HomeRemoteDataManagerInputProtocol: AnyObject {
    // INTERACTOR -> REMOTEDATAMANAGER
    var remoteRequestHandler: HomeRemoteDataManagerOutputProtocol? { get set }
}

protocol HomeRemoteDataManagerOutputProtocol {
    // REMOTEDATAMANAGER -> INTERACTOR
}

protocol HomeLocalDataManagerInputProtocol {
    // INTERACTOR -> LOCALDATAMANAGER
}
