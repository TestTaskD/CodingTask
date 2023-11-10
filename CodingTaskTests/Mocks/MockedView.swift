//
//  MockedView.swift
//  CodingTaskTests
//
//  Created by Denis Aleshyn on 10/11/2023.
//

import Foundation
import CodingTask

class MockedView: ViewProtocol {
    var isReloaded: Bool = false
    var isShownAlert: Bool = false
    
    func show(_ error: Error) {
        isShownAlert = true
    }
    
    func reload() {
        isReloaded = true
    }
}
