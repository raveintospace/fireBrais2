//
//  LogedProtocols.swift
//  FireBraisTwo
//
//  Created by Uri on 29/1/23.
//

import Foundation
import UIKit

protocol LogedViewProtocol: AnyObject {
    // PRESENTER -> VIEW
    var presenter: LogedPresenterProtocol? { get set }
    func setupLogedView()
    func setDataInLogedVC(email: String, provider: ProviderType)
}

protocol LogedWireFrameProtocol {
    // PRESENTER -> WIREFRAME
    static func createLogedModule(email: String, provider: ProviderType) -> UIViewController
    
    func presentHomeView(view: LogedViewProtocol)
}

protocol LogedPresenterProtocol: AnyObject {
    // VIEW -> PRESENTER
    var view: LogedViewProtocol? { get set }
    var interactor: LogedInteractorInputProtocol? { get set }
    var wireFrame: LogedWireFrameProtocol? { get set }
    var emailReceived: String? { get set }
    var providerReceived: ProviderType? { get set }
    
    func viewDidLoad()
    
    func goBackToHomeView()
}

protocol LogedInteractorOutputProtocol {
    // INTERACTOR -> PRESENTER
}

protocol LogedInteractorInputProtocol: AnyObject {
    // PRESENTER -> INTERACTOR
    var presenter: LogedInteractorOutputProtocol? { get set }
    var localDatamanager: LogedLocalDataManagerInputProtocol? { get set }
    var remoteDatamanager: LogedRemoteDataManagerInputProtocol? { get set }
}

protocol LogedDataManagerInputProtocol {
    // INTERACTOR -> DATAMANAGER
}

protocol LogedRemoteDataManagerInputProtocol: AnyObject {
    // INTERACTOR -> REMOTEDATAMANAGER
    var remoteRequestHandler: LogedRemoteDataManagerOutputProtocol? { get set }
}

protocol LogedRemoteDataManagerOutputProtocol {
    // REMOTEDATAMANAGER -> INTERACTOR
}

protocol LogedLocalDataManagerInputProtocol {
    // INTERACTOR -> LOCALDATAMANAGER
}

protocol LogoutProtocol {
    func logoutButtonWasPressed()
}
