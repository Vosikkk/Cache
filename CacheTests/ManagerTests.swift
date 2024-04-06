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
    
    
    func test_add_elementToProviders_shouldSaveElements() {
       
        let sut = makeSUT(with: provider1, provider2)
        XCTAssertTrue(provider1.data.isEmpty)
        XCTAssertTrue(provider2.data.isEmpty)
        
        sut.add(test.values.first!, forKey: 1)
       
        XCTAssertEqual(provider1.data.count, 1)
        XCTAssertEqual(provider1.data[1], test.values.first)
        XCTAssertEqual(provider2.data.count, 1)
        XCTAssertEqual(provider2.data[1], test.values.first)
        
        
        sut.add(test2.values.first!, forKey: 2)
        XCTAssertEqual(provider1.data.count, 2)
        XCTAssertEqual(provider1.data[2], test2.values.first)
        
        XCTAssertEqual(provider2.data.count, 2)
        XCTAssertEqual(provider2.data[2], test2.values.first)
        
    }
    
    
    func test_add_elementToConcreteProvider_shouldSaveElementsOnlyOnConcreteProvider() {
       
        let sut = makeSUT(with: provider1, provider2)
        XCTAssertTrue(provider1.data.isEmpty)
        XCTAssertTrue(provider2.data.isEmpty)
        
        sut.add(test.values.first!, forKey: 1)
       
        XCTAssertEqual(provider1.data.count, 1)
        XCTAssertEqual(provider1.data[1], test.values.first)
        XCTAssertEqual(provider2.data.count, 1)
        XCTAssertEqual(provider2.data[1], test.values.first)
        
        
        sut.add(to: provider2, test2.values.first!, forKey: 2)
        XCTAssertEqual(provider1.data.count, 1)
        XCTAssertEqual(provider1.data[2], nil)
        
        XCTAssertEqual(provider2.data.count, 2)
        XCTAssertEqual(provider2.data[2], test2.values.first)
    }
    
    
    func test_getElementByKey_shouldReturnElementFromProvider() {
        
        let sut = makeSUT(with: provider1)
        
        sut.add(test.values.first!, forKey: 1)
        sut.add(test.values.first!, forKey: 2)
        
        XCTAssertEqual(sut.get(by: 1), test.values.first!)
        XCTAssertEqual(sut.get(by: 2), test.values.first!)
    }
    
    func test_getElementByKey_fromConreteProvider_shouldReturnElementFromConcreteProvider() {
        
        let sut = makeSUT(with: provider1, provider2)
        
        sut.add(test.values.first!, forKey: 1)
        sut.add(to: provider2, test.values.first!, forKey: 2)
        
        XCTAssertEqual(sut.get(by: 1), test.values.first!)
        XCTAssertEqual(sut.get(by: 2, fromConcrete: provider1), nil)
    }
    
    
    func test_removeProvider_shouldRemoveProviderFromArray() {
        
        let sut = makeSUT(with: provider1, provider2)
        XCTAssertEqual(sut.providersCount, 2)
        
        sut.remove(provider1)
        
        XCTAssertEqual(sut.providersCount, 1)

    }
    
    
    
   

    
    
    // MARK: - Helpers
    
    
    private class ProviderMock: StorageProvider, Remover {
        
        
        var id: UUID = UUID()
        
        private(set) var data: [Int: [String]] = [:]
        
        func get(by key: Int) -> [String]? {
             data[key]
        }
    
        func add(_ element: [String], forKey key: Int) {
             data[key] = element
        }
        
        func remove(_ element: [String]) {
            for (key, value) in data {
                if value == element {
                    data.removeValue(forKey: key)
                    break
                }
            }
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
