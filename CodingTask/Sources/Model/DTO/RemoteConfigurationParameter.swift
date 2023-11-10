//
//  RemoteConfigurationParameter.swift
//  CodingTask
//
//  Created by Denis Aleshyn on 06/11/2023.
//

import Foundation

public protocol RemoteConfigurationParameter {
    var key: String { get }
    func asDictionary() -> [String: NSObject]
}

struct ConfigStringValue {
    private(set) var key: String
    let value: String
}

extension ConfigStringValue: RemoteConfigurationParameter {
    func asDictionary() -> [String : NSObject] {
        return  [key: value as NSObject]
    }
}
