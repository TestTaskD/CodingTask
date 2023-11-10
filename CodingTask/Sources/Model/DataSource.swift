//
//  DataSource.swift
//  CodingTask
//
//  Created by Denis Aleshyn on 06/11/2023.
//

import Foundation
import Firebase

public protocol DataSourceProtocol {
    func getAll() async throws -> [ConfigItemModel]
    
    var defaultValues: [RemoteConfigurationParameter] { get }
    var onConfigUpdate: ((Result<[ConfigItemModel], Error>) -> Void)? { get set }
}

// function signature for protocol to moke remote config for testing purposes
// func addOnConfigUpdateListener(remoteConfigUpdateCompletion listener: @escaping (RemoteConfigUpdate?, Error?) -> Void) -> ConfigUpdateListenerRegistration

final class FirebaseDataSource {
    private let firebaseRemoteConfiguration: RemoteConfig
    
    private(set) var defaultValues: [RemoteConfigurationParameter]
    
    var onConfigUpdate: ((Result<[ConfigItemModel], Error>) -> Void)?
    
    init(defaultValues: [RemoteConfigurationParameter]) {
        self.defaultValues = defaultValues
        
        firebaseRemoteConfiguration = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        firebaseRemoteConfiguration.configSettings = settings
        
        setup()
    }
    
    private func setup() {
        let defaults = defaultValues.compactMap {$0.asDictionary()}
        
        firebaseRemoteConfiguration.setDefaults(defaults.first)
        
        firebaseRemoteConfiguration.addOnConfigUpdateListener { [weak self] configUpdate, error in
            if let error = error {
                self?.onConfigUpdate?(.failure(error))
            } else {
                self?.firebaseRemoteConfiguration.activate()
                let models = configUpdate?.updatedKeys.compactMap { key in
                    let dictionary = self?.firebaseRemoteConfiguration.configValue(forKey: key).jsonValue as? [String: Any]
                    return ConfigItemModel(dictionary: dictionary, key: key)
                } ?? [ConfigItemModel]()
                self?.onConfigUpdate?(.success(models))
            }
        }
    }
}

extension FirebaseDataSource: DataSourceProtocol {
    func getAll() async throws -> [ConfigItemModel] {
        return try await withUnsafeThrowingContinuation({ continuation in
            firebaseRemoteConfiguration.fetchAndActivate { (status, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    let itemModels = self.defaultValues.compactMap({
                        let dictionary = self.firebaseRemoteConfiguration.configValue(forKey: $0.key).jsonValue as? [String: Any]
                        print("")
                        return ConfigItemModel(dictionary: dictionary, key: $0.key)
                    })
                    continuation.resume(returning: itemModels)
                }
            }
        })
    }
        
}
