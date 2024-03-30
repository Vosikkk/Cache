//
//  CacheTests.swift
//  CacheTests
//
//  Created by Саша Восколович on 28.03.2024.
//

import XCTest
@testable import Cache

final class CacheTests: XCTestCase {

    func test_add_twoElements_shouldSaveElements() {
       
        let sut = makeSUT()
        XCTAssertTrue(cache.data.isEmpty)
       
        sut.save(test)
        XCTAssertEqual(cache.data.count, 1)
        XCTAssertEqual(cache.data[1], test.values.first)
        
        sut.save(test2)
        XCTAssertEqual(cache.data.count, 2)
        XCTAssertEqual(cache.data[2], test2.values.first)
    }
    
    
    func test_add_oneElementAndThenChangeValue_shouldChangeValueByExistingKey() {
       
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
//        XCTAssertTrue(cache.elements.isEmpty)
//        XCTAssertEqual(sut.get(test), nil)
//        
//        sut.save(test)
//        XCTAssertEqual(cache.elements.count, 1)
//        
//        XCTAssertEqual(sut.get(test), test)
//    }
//    
//    
//    func test_updatingElement_shouldUpdateValue() {
//         let sut = makeSUT()
//         
//         sut.save(test)
//         XCTAssertEqual(cache.elements.first?.value, test)
//        
//         
//        
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
    
    private func makeSUT() -> Storage<CacheMock> {
        let sut = Storage(provider: cache)
        return sut
    }
}
