//
//  PresenterTest.swift
//  CodingTaskTests
//
//  Created by Denis Aleshyn on 09/11/2023.
//

import XCTest
import Foundation

@testable import CodingTask

final class PresenterTest: XCTestCase {
    
    var sut:Presenter!

    override func tearDown() {
        sut = nil
    }

    func testPresenter_whenPresenterInitialized_onConfigUpdateIsSet() {
        // Given
        let dataSource = MockedDataSource()
        
        // When
        sut = Presenter(dataSource: dataSource)
        
        // Than
        XCTAssertNotNil(dataSource.onConfigUpdate)
    }
    
    func testPresenter_whenStartFunctionIsCalled_getAllFunctionIsCalledAsWell() async {
        // Given
        let dataSource = MockedDataSource()
        let expectation = XCTestExpectation()
        let mokedRequestConfigTime  = 0.5
        
        // When
        sut = Presenter(dataSource: dataSource)
        sut.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + mokedRequestConfigTime) {
            expectation.fulfill()
            XCTAssertTrue(dataSource.isGetAllFunctionInvoked)
        }
        // Than
        await fulfillment(of: [expectation])
    }
    
    func testPresenter_whenConfigUpdatedSuccessful_viewIsReloaded() {
        // Given
        let dataSource = MockedDataSource()
        let view = MockedView()
       
        // When
        sut = Presenter(dataSource: dataSource)
        sut.view = view
        dataSource.onConfigUpdate?(.success([ConfigItemModel]()))
        
        // Than
        XCTAssertTrue(view.isReloaded)
    }
    
    func testPresenter_whenConfigUpdateErrorOccured_errorIsShown() {
        // Given
        let dataSource = MockedDataSource()
        let view = MockedView()
       
        // When
        sut = Presenter(dataSource: dataSource)
        sut.view = view
        dataSource.onConfigUpdate?(.failure(MockedDataSource.ConfigError.updateConfigError))
        
        // Than
        XCTAssertTrue(view.isShownAlert)
    }
    
   
    func testPresenter_whenConfigFetchedSuccessful_viewIsReloaded() async {
        // Given
        let dataSource = MockedDataSource()
        let view = MockedView()
        let expectation = XCTestExpectation()
        let mockedRequestConfigTime  = 0.5
        
        // When
        sut = Presenter(dataSource: dataSource)
        sut.view = view
        sut.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + mockedRequestConfigTime) {
            expectation.fulfill()
            XCTAssertTrue(view.isReloaded)
        }
        
        // Than
        await fulfillment(of: [expectation])
    }
    
    func testPresenter_whenConfigFetchErrorOccured_errorIsShown() async {
        // Given
        let dataSource = MockedDataSource()
        dataSource.isSuccessfulCase = false
        let view = MockedView()
        let expectation = XCTestExpectation()
        let mockedRequestConfigTime  = 0.5
        
        // When
        sut = Presenter(dataSource: dataSource)
        sut.view = view
        sut.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + mockedRequestConfigTime) {
            expectation.fulfill()
            XCTAssertTrue(view.isShownAlert)
        }
        
        // Than
        await fulfillment(of: [expectation])
    }
}

