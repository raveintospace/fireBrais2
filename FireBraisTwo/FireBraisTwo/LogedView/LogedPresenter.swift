//
//  LogedPresenter.swift
//  FireBraisTwo
//
//  Created by Uri on 29/1/23.
//

import Foundation

final class LogedPresenter: LogedPresenterProtocol  {
    
    // MARK: Properties
    weak var view: LogedViewProtocol?
    var interactor: LogedInteractorInputProtocol?
    var wireFrame: LogedWireFrameProtocol?
    var emailReceived: String?
    var providerReceived: ProviderType?
    
    func viewDidLoad() {
        if let emailReceived = emailReceived, let providerReceived = providerReceived {
            view?.setupLogedView()
            view?.setDataInLogedVC(email: emailReceived, provider: providerReceived)
        }
    }
    
    func goBackToHomeView() {
        wireFrame?.presentHomeView(view: view!)
    }

}

extension LogedPresenter: LogedInteractorOutputProtocol {
    // TODO: implement interactor output methods
}
