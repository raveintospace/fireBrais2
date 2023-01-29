//
//  LogedWireFrame.swift
//  FireBraisTwo
//
//  Created by Uri on 29/1/23.
//

import Foundation
import UIKit

final class LogedWireFrame: LogedWireFrameProtocol {
    
    static func createLogedModule(email: String, provider: ProviderType) -> UIViewController {
        let view = LogedView()
        let presenter: LogedPresenterProtocol & LogedInteractorOutputProtocol = LogedPresenter()
        let interactor: LogedInteractorInputProtocol & LogedRemoteDataManagerOutputProtocol = LogedInteractor()
        let localDataManager: LogedLocalDataManagerInputProtocol = LogedLocalDataManager()
        let remoteDataManager: LogedRemoteDataManagerInputProtocol = LogedRemoteDataManager()
        let wireFrame: LogedWireFrameProtocol = LogedWireFrame()
        
        view.presenter = presenter
        presenter.view = view
        presenter.wireFrame = wireFrame
        presenter.interactor = interactor
        presenter.emailReceived = email
        presenter.providerReceived = provider
        interactor.presenter = presenter
        interactor.localDatamanager = localDataManager
        interactor.remoteDatamanager = remoteDataManager
        remoteDataManager.remoteRequestHandler = interactor
        
        return view
    }
    
    func presentHomeView(view: LogedViewProtocol) {
        let currentViewController = view as! LogedView
        
        currentViewController.navigationController?.popToRootViewController(animated: true)
        
        // ask to remove data using destinationVC presenter
        // notify destinationvc using delegate that is current view controller
        // https://youtu.be/ZH39YDCIK-0 minut 8 - dj
    }
}
