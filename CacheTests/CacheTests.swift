//
//  CacheTests.swift
//  CacheTests
//
//  Created by Саша Восколович on 28.03.2024.
//

import XCTest
@testable import Cache

final class CacheTests: XCTestCase {

   
    func test_add_twoElements_shouldIncreaseCount() {
        let sut = CacheMock()
        let test: [String: String] = ["1": "Test"]
        let test2: [String: String] = ["2": "Test2"]
       
        
        XCTAssertEqual(sut.callCount, 0)
       
        sut.add(test)
        
        XCTAssertEqual(sut.lastAddedElement, test)
        XCTAssertEqual(sut.callCount, 1)
        
        sut.add(test2)
        
        XCTAssertEqual(sut.lastAddedElement, test2)
        XCTAssertEqual(sut.callCount, 2)
        
    }
    
    
    private class CacheMock: Cache {
       
        private(set) var callCount: Int = 0
        private(set) var lastAddedElement: [String: String] = [:]
        var callback: ([String: String]) -> Void = { _ in }
        
        func add(_ element: [String: String]) {
            lastAddedElement = element
            callCount += 1
        }
        
        func get(_ element: [String: String]) -> [String: String] {
            
            return [:]
        }
        
        
        func update(from old: [String: String], to new: [String: String]) {
            
        }
    }
}
