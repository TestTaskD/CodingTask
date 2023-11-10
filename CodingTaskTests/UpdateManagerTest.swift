//
//  UpdateManagerTest.swift
//  CodingTaskTests
//
//  Created by Denis Aleshyn on 10/11/2023.
//

import Foundation
import XCTest

@testable import CodingTask

class UpdateManagerTest: XCTestCase {
    
    var sut:UpdateManager!
    
    override func setUp() async throws {
        sut = UpdateManager()
    }

    override func tearDown() {
        sut = nil
    }
    
    func testUpdateManager_whenNeedsToAddItems_updateTypeIsAddition() {
        // Given
        let existingCollection = [ConfigItemModel(key: "Key1", image: .init(url: "url", isHidden: false))]
        let newConfigElement = ConfigItemModel(key: "Key2", image: .init(url: "url", isHidden: false))
        
        // When
        let updateType = sut.typeOfUpdate(for: existingCollection, itemToUpdate: newConfigElement)
        
        // Then
        XCTAssertNotNil(updateType)
        XCTAssertEqual(updateType, UpdateType.addition(element: newConfigElement))
    }
    
    func testUpdateManager_whenMaximumReached_updateTypeIsNil() {
        // Given
        let existingCollection = [
            ConfigItemModel(key: "Key1", image: .init(url: "url", isHidden: false)),
            ConfigItemModel(key: "Key2", image: .init(url: "url", isHidden: false)),
            ConfigItemModel(key: "Key3", image: .init(url: "url", isHidden: false)),
            ConfigItemModel(key: "Key4", image: .init(url: "url", isHidden: false)),
            ConfigItemModel(key: "Key5", image: .init(url: "url", isHidden: false)),
            ConfigItemModel(key: "Key6", image: .init(url: "url", isHidden: false))
        ]
        let newConfigElement = ConfigItemModel(key: "Key7", image: .init(url: "url", isHidden: false))
        
        // When
        let updateType = sut.typeOfUpdate(for: existingCollection, itemToUpdate: newConfigElement)
        
        // Then
        XCTAssertNil(updateType)
    }
    
    func testUpdateManager_whenNoNeedsToAddItems_updateTypeIsNil() {
        // Given
        let existingCollection = [
            ConfigItemModel(key: "Key1", image: .init(url: "url", isHidden: false)),
           
        ]
        let newConfigElement = ConfigItemModel(key: "Key2", image: nil)
        
        // When
        let updateType = sut.typeOfUpdate(for: existingCollection, itemToUpdate: newConfigElement)
        
        // Then
        XCTAssertNil(updateType)
    }
    
    func testUpdateManager_whenNeedsToUpdateItems_updateTypeIsUpdate() {
        // Given
        let existingCollection = [ConfigItemModel(key: "Key1", image: .init(url: "url", isHidden: false))]
        let updatedConfigElement = ConfigItemModel(key: "Key1", image: .init(url: "url", isHidden: true))
        
        // When
        let updateType = sut.typeOfUpdate(for: existingCollection, itemToUpdate: updatedConfigElement)
        
        // Then
        XCTAssertNotNil(updateType)
        XCTAssertEqual(updateType, UpdateType.editing(element: updatedConfigElement, atIndex: 0))
    }
    
    
    
    func testUpdateManager_whenNeedsToDeleteItems_updateTypeIsDeletion() {
        // Given
        let existingCollection = [ConfigItemModel(key: "Key1", image: .init(url: "url", isHidden: false))]
        let updatedConfigElement = ConfigItemModel(key: "Key1", image: nil)
        
        // When
        let updateType = sut.typeOfUpdate(for: existingCollection, itemToUpdate: updatedConfigElement)
        
        // Then
        XCTAssertNotNil(updateType)
        XCTAssertEqual(updateType, UpdateType.deletion(atIndex: 0))
    }
}
