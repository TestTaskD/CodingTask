//
//  DataSource.swift
//  CodingTask
//
//  Created by Denis Aleshyn on 06/11/2023.
//

import Foundation
import Firebase

protocol DataSourceProtocol {
    func getAll() async throws -> [ScreenItemModel]
    
    var defaultValues: [RemoteConfigurationParameter] { get }
    var onUpdate: ((Result<[ScreenItemModel], Error>) -> Void)? { get set }
}

class FirebaseDataSource {
    private let firebaseRemoteConfiguration: RemoteConfig
    
    private(set) var defaultValues: [RemoteConfigurationParameter]
    
    var onUpdate: ((Result<[ScreenItemModel], Error>) -> Void)?
    
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
                self?.onUpdate?(.failure(error))
            } else {
                self?.firebaseRemoteConfiguration.activate()
                let models = configUpdate?.updatedKeys.compactMap { key in
                    let dictionary = self?.firebaseRemoteConfiguration.configValue(forKey: key).jsonValue as? [String: Any]
                    return ScreenItemModel(dictionary: dictionary)
                } ?? [ScreenItemModel]()
                self?.onUpdate?(.success(models))
            }
        }
    }
}

extension FirebaseDataSource: DataSourceProtocol {
    func getAll() async throws -> [ScreenItemModel] {
        return try await withUnsafeThrowingContinuation({ continuation in
            firebaseRemoteConfiguration.fetchAndActivate { (status, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    let itemModels = self.defaultValues.compactMap({
                        let dictionary = self.firebaseRemoteConfiguration.configValue(forKey: $0.key).jsonValue as? [String: Any]
                        print("")
                        return ScreenItemModel(dictionary: dictionary)
                    })
                    continuation.resume(returning: itemModels)
                }
            }
        })
    }
}