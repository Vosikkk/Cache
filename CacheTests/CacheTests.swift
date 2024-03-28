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
        
        XCTAssertTrue(cache.elements.isEmpty)
       
        sut.save(test)
        XCTAssertEqual(cache.elements[test], test)
        XCTAssertEqual(cache.elements.count, 1)
        
        
        sut.save(test2)
        XCTAssertEqual(cache.elements[test2], test2)
        XCTAssertEqual(cache.elements.count, 2)
    }
    
    func test_get_withNotEmptyCache_shouldReturnElement() {
        let sut = makeSUT()
       
        XCTAssertTrue(cache.elements.isEmpty)
        XCTAssertEqual(sut.get(test), nil)
        
        sut.save(test)
        XCTAssertEqual(cache.elements.count, 1)
        
        XCTAssertEqual(sut.get(test), test)
    }
    
    
    
    
    // MARK: - Helpers
    
    private class CacheMock: Cache {
        
        private(set) var elements: [String: String] = [:]
        var callback: ([String: String]) -> Void = { _ in }
        
        func get(_ element: String) -> String? {
             elements[element]
        }
        
        func add(_ element: String) {
            elements[element] = element
        }

        func update(_ element: String) {
            
        }
    }
    
    private var test: String {
        "Test"
    }
    
    private var test2: String {
        "Test2"
    }
    
    private let cache: CacheMock = CacheMock()
    
    private func makeSUT() -> Storage<CacheMock> {
        let sut = Storage(cache: cache)
        return sut
    }
}
