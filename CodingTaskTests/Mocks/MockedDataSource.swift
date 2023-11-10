//
//  MockedDataSource.swift
//  CodingTaskTests
//
//  Created by Denis Aleshyn on 10/11/2023.
//

import Foundation
import CodingTask

class MockedDataSource: DataSourceProtocol {
    enum ConfigError: Error {
        case updateConfigError
    }
    
    var isGetAllFunctionInvoked: Bool = false
    var isSuccessfulCase: Bool = true
    
    func getAll() async throws -> [ConfigItemModel] {
        if isSuccessfulCase {
            isGetAllFunctionInvoked = true
            return [ConfigItemModel]()
        } else {
            throw ConfigError.updateConfigError
        }
    }
    
    var defaultValues: [RemoteConfigurationParameter] = []
    var onConfigUpdate: ((Result<[ConfigItemModel], Error>) -> Void)?
}
