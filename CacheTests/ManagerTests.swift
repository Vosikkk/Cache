//
//  ManagerTests.swift
//  CacheTests
//
//  Created by Саша Восколович on 06.04.2024.
//

import XCTest
@testable import Cache


final class ManagerTests: XCTestCase {

    
    
    func test_initProviders_providersCountEqualAsAddedProviders() {
        
        let sut1 = makeSUT(with: provider1)
        XCTAssertEqual(sut1.providersCount, 1)
        
        let sut2 = makeSUT(with: provider1, provider2)
        XCTAssertEqual(sut2 .providersCount, 2)
        
        
        let sut3 = makeSUT(with: provider1, provider2, provider3)
        XCTAssertEqual(sut3.providersCount, 3)
    }
    
    
    func test_add_elementToProvider_shouldSaveElements() {
       
        let sut = makeSUT(with: provider1)
        XCTAssertTrue(provider1.data.isEmpty)
        
        sut.add(test.values.first!, for: 1)
        XCTAssertEqual(provider1.data.count, 1)
        XCTAssertEqual(provider1.data[1], test.values.first)
        
        sut.add(test2.values.first!, for: 2)
        XCTAssertEqual(provider1.data.count, 2)
        XCTAssertEqual(provider1.data[2], test2.values.first)
    }
    
   

    
    
    // MARK: - Helpers
    
    
    private class ProviderMock: Provider {
        var id: UUID = UUID()
        
        private(set) var data: [Int: [String]] = [:]
        
        func get(by key: Int) -> [String]? {
             data[key]
        }
    
      
        func add(_ element: [String], for key: Int) {
             data[key] = element
        }
    }
    
    
    private var test: [Int: [String]] {
        [1: ["Test1"]]
    }
    
    private var test2: [Int: [String]] {
        [2: ["Test2"]]
    }
    
    private var test3: [Int: [String]] {
        [1: ["Test3"]]
    }
    
    private let provider1: ProviderMock = ProviderMock()
    private let provider2: ProviderMock = ProviderMock()
    private let provider3: ProviderMock = ProviderMock()
   
    private func makeSUT(with providers: ProviderMock...) -> ManagerProvider<ProviderMock> {
        
        switch providers.count {
        case 1:
            return ManagerProvider(providers: providers[0])
        case 2:
            return ManagerProvider(providers: providers[0], providers[1])
        case 3:
            return ManagerProvider(providers: providers[0], providers[1], providers[2])
        default:
            return ManagerProvider(providers: provider1)
        }
    }
}
