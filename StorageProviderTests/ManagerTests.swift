//
//  ManagerTests.swift
//  CacheTests
//
//  Created by Саша Восколович on 06.04.2024.
//

import XCTest
@testable import StorageProvider


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
        
        sut.save(test.value, forKey: test.key)
       
        XCTAssertEqual(provider1.data.count, 1)
        XCTAssertEqual(provider1.data[test.key], test.value)
        XCTAssertEqual(provider2.data.count, 1)
        XCTAssertEqual(provider2.data[test.key], test.value)
        
        
        sut.save(test2.value, forKey: test2.key)
        XCTAssertEqual(provider1.data.count, 2)
        XCTAssertEqual(provider1.data[test2.key], test2.value)
        
        XCTAssertEqual(provider2.data.count, 2)
        XCTAssertEqual(provider2.data[test2.key], test2.value)
        
    }
    
    
    func test_add_elementToConcreteProvider_shouldSaveElementsOnlyOnConcreteProvider() {
       
        let sut = makeSUT(with: provider1, provider2)
        XCTAssertTrue(provider1.data.isEmpty)
        XCTAssertTrue(provider2.data.isEmpty)
        
        sut.save(test.value, forKey: test.key)
       
        XCTAssertEqual(provider1.data.count, 1)
        XCTAssertEqual(provider1.data[test.key], test.value)
        XCTAssertEqual(provider2.data.count, 1)
        XCTAssertEqual(provider2.data[test.key], test.value)
        
        
        sut.add(to: provider2, test2.value, forKey: test2.key)
        XCTAssertEqual(provider1.data.count, 1)
        XCTAssertEqual(provider1.data[test2.key], nil)
        
        XCTAssertEqual(provider2.data.count, 2)
        XCTAssertEqual(provider2.data[test2.key], test2.value)
    }
    
    
    func test_getElementByKey_shouldReturnElementFromProvider() {
        
        let sut = makeSUT(with: provider1)
        
        sut.save(test.value, forKey: test.key)
        sut.save(test.value, forKey: test2.key)
        
        XCTAssertEqual(sut.get(by: test.key), test.value)
        XCTAssertEqual(sut.get(by: test2.key), test.value)
    }
    
    func test_getElementByKey_fromConreteProvider_shouldReturnElementFromConcreteProvider() {
        
        let sut = makeSUT(with: provider1, provider2)
        
        sut.save(test.value, forKey: test.key)
        sut.add(to: provider2, test.value, forKey: test2.key)
        
        XCTAssertEqual(sut.get(by: test.key), test.value)
        XCTAssertEqual(sut.get(by: test2.key, fromConcrete: provider1), nil)
    }
    
    
    func test_removeProvider_shouldRemoveProviderFromArray() {
        let sut = makeSUT(with: provider1, provider2)
        
        XCTAssertEqual(sut.providersCount, 2)
        XCTAssertEqual(sut.remove(provider1)?.id, provider1.id)
        XCTAssertEqual(sut.providersCount, 1)
    }
    
    func test_removeElementFromConcreteProvider_shouldRemmoveElementAndReturnIt() {
        
        let sut = makeSUT(with: provider1)
        
        sut.save(test.value, forKey: test.key)
        
        XCTAssertEqual(sut.remove(elementByKey: test.key, from: provider1), test.value)
        
        XCTAssertEqual(sut.get(by: test.key), nil)
        
    }
    
    
    // MARK: - Helpers
    
    
    private class ProviderMock: StorageProvider, Remover {
        
        
        var id: UUID = UUID()
        
        private(set) var data: [Int: [String]] = [:]
        
        func get(by key: Int) -> [String]? {
             data[key]
        }
    
        func save(_ element: [String], forKey key: Int) {
             data[key] = element
        }
        
        func remove(byKey key: Int) -> [String]? {
            data.removeValue(forKey: key)
        }
    }
    
    
    private var test: (key: Int, value: [String]) {
        (1, ["Test"])
    }
    
    private var test2: (key: Int, value: [String]) {
        (2, ["Test2"])
    }
    
    private var test3: (key: Int, value: [String]) {
        (3, ["Test3"])
    }
    
    private let provider1: ProviderMock = ProviderMock()
    private let provider2: ProviderMock = ProviderMock()
    private let provider3: ProviderMock = ProviderMock()
   
    
    
    private func makeSUT(with providers: ProviderMock...) -> ManagerProvider<ProviderMock> {
        var sut: ManagerProvider<ProviderMock>
        switch providers.count {
        case 1:
            sut = ManagerProvider(providers: providers[0])
        case 2:
            sut = ManagerProvider(providers: providers[0], providers[1])
        case 3:
            sut = ManagerProvider(providers: providers[0], providers[1], providers[2])
        default:
            sut = ManagerProvider(providers: provider1)
        }
        return sut
    }
}
