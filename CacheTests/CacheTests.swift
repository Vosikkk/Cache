//
//  CacheTests.swift
//  CacheTests
//
//  Created by Саша Восколович on 28.03.2024.
//

import XCTest
@testable import Cache

final class CacheTests: XCTestCase {

    func test_save_twoElementsWhenSetOneProvider_shouldSaveElements() {
       
        let sut = makeSUT()
        XCTAssertTrue(cache.data.isEmpty)
        sut.set(active: cache)
        sut.save(test)
        XCTAssertEqual(cache.data.count, 1)
        XCTAssertEqual(cache.data[1], test.values.first)
        
        sut.save(test2)
        XCTAssertEqual(cache.data.count, 2)
        XCTAssertEqual(cache.data[2], test2.values.first)
    }
    
    
    func test_save_elementToTwoProvidersAndAddOneMoreElementToConcreteProvider_shouldSaveNewElementOnlyForConcrete() {
       
       
        let sut = makeSUT(moreThanOneCaches: true)
        
        XCTAssertTrue(cache.data.isEmpty)
        XCTAssertTrue(cache2.data.isEmpty)
        sut.save(test, addToAllProviders: true)
        XCTAssertEqual(cache.data.count, 1)
        XCTAssertEqual(cache2.data.count, 1)
        
        XCTAssertEqual(cache.data[1], test.values.first)
        XCTAssertEqual(cache2.data[1], test.values.first)
        
        sut.save(test2, to: cache2)
        XCTAssertEqual(cache.data.count, 1)
        XCTAssertEqual(cache2.data.count, 2)
        XCTAssertEqual(cache2.data[2], test2.values.first)
    }
    
    
    func test_save_twoElementsWhenTwoProviders_shouldSaveElementsToTwoProviders() {
       
        let sut = makeSUT(moreThanOneCaches: true)
        
        XCTAssertTrue(cache.data.isEmpty)
        XCTAssertTrue(cache2.data.isEmpty)
        
        sut.save(test, addToAllProviders: true)
        XCTAssertEqual(cache.data.count, 1)
        XCTAssertEqual(cache2.data.count, 1)
        XCTAssertEqual(cache.data[1], test.values.first)
        XCTAssertEqual(cache2.data[1], test.values.first)
        
        
        sut.save(test2, addToAllProviders: true)
        XCTAssertEqual(cache.data.count, 2)
        XCTAssertEqual(cache2.data.count, 2)
        XCTAssertEqual(cache.data[2], test2.values.first)
        XCTAssertEqual(cache2.data[2], test2.values.first)
    }
    
    
    func test_save_twoElementsWhenSetProvider_shouldSaveElements() {
       
        let sut = makeSUT()
        XCTAssertTrue(cache.data.isEmpty)
        sut.set(active: cache)
        sut.save(test)
        XCTAssertEqual(cache.data.count, 1)
        XCTAssertEqual(cache.data[1], test.values.first)
        
        sut.save(test2)
        XCTAssertEqual(cache.data.count, 2)
        XCTAssertEqual(cache.data[2], test2.values.first)
    }
    
    
    func test_save_oneElementAndThenChangeValueWhenSetOneProvider_shouldChangeValueByExistingKey() {
       
        let sut = makeSUT()
        XCTAssertTrue(cache.data.isEmpty)
        sut.set(active: cache)
        sut.save(test)
        XCTAssertEqual(cache.data.count, 1)
        XCTAssertEqual(cache.data[1], test.values.first)
        
        sut.save(test3)
        XCTAssertEqual(cache.data.count, 1)
        XCTAssertEqual(cache.data[1], test3.values.first)
    }
    
    
    func test_save_oneElementAndThenChangeValueWhenDefaultProvider_shouldChangeValueByExistingKey() {
       
        let sut = makeSUT()
        XCTAssertTrue(cache.data.isEmpty)
        
        sut.save(test)
        XCTAssertEqual(cache.data.count, 1)
        XCTAssertEqual(cache.data[1], test.values.first)
        
        sut.save(test3)
        XCTAssertEqual(cache.data.count, 1)
        XCTAssertEqual(cache.data[1], test3.values.first)
    }
    

//    func test_get_withNotEmptyCache_shouldReturnElement() {
//        let sut = makeSUT()
//        
//        XCTAssertTrue(cache.data.isEmpty)
//        
//        sut.save(test)
//        XCTAssertEqual(sut.get(test.keys.first!), cache.data[1])
//        
//        sut.save(test2)
//        XCTAssertEqual(sut.get(test2.keys.first!), cache.data[2])
//    }
//    
//    func test_get_withNotEmptyCache_shouldReturnElement() {
//        let sut = makeSUT()
//        
//        XCTAssertTrue(cache.data.isEmpty)
//        
//        sut.save(test)
//        XCTAssertEqual(sut.get(test.keys.first!), cache.data[1])
//        
//        sut.save(test2)
//        XCTAssertEqual(sut.get(test2.keys.first!), cache.data[2])
//    }
    
    
    

    
        
    // MARK: - Helpers
    
    
    private class CacheMock: StorageProvider {
        
        private(set) var data: [Int: [String]] = [:]
        
        func get(by key: Int) -> [String]? {
             data[key]
        }
    
      
        func add(_ element: [String], for key: Int) {
             data[key] = element
        }
    }
    
    private var test:  [Int: [String]] {
        [1: ["Test1"]]
    }
    
    private var test2: [Int: [String]] {
        [2: ["Test2"]]
    }
    
    private var test3: [Int: [String]] {
        [1: ["Test3"]]
    }
    
    private let cache: CacheMock = CacheMock()
    private let cache2: CacheMock = CacheMock()
   
    private func makeSUT(moreThanOneCaches: Bool = false) -> Storage<CacheMock> {
        let sut = moreThanOneCaches ? Storage(cache, cache2) : Storage(cache)
        return sut
    }
}
