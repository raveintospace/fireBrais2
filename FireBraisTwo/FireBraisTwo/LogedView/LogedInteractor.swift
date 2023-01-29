//
//  LogedInteractor.swift
//  FireBraisTwo
//
//  Created by Uri on 29/1/23.
//

import Foundation

class LogedInteractor: LogedInteractorInputProtocol {

    // MARK: Properties
    var presenter: LogedInteractorOutputProtocol?
    var localDatamanager: LogedLocalDataManagerInputProtocol?
    var remoteDatamanager: LogedRemoteDataManagerInputProtocol?

}

extension LogedInteractor: LogedRemoteDataManagerOutputProtocol {
    
}
