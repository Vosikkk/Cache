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
        XCTAssertEqual(cache.data[0].data, test.data)
        
        sut.save(test2)
        XCTAssertEqual(cache.data.count, 2)
        XCTAssertEqual(cache.data[1].data, test2.data)
    }
    
    
    func test_add_oneElementAndThenChangeValue_shouldChangeValueByExistingKey() {
       
        let sut = makeSUT()
        XCTAssertTrue(cache.data.isEmpty)
       
        sut.save(test)
        XCTAssertEqual(cache.data.count, 1)
        XCTAssertEqual(cache.data[0].data, test.data)
        
        sut.save(test3)
        XCTAssertEqual(cache.data.count, 1)
        XCTAssertEqual(cache.data[0].data, test3.data)
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
        
        private(set) var data: [(key: Int, data: String)] = []
        
        func get(by key: Int) -> String? {
             data.first(where: { $0.key == key})?.data
        }
        
        func update(old keyElement: Key, on newData: Element) {
            if let index = data.firstIndex(where: { $0.key == keyElement }) {
                data[index].data = newData
            }
        }
      
        func add(_ element: (key: Int, data: String)) {
            data.append(element)
        }
    }
    
    private var test: (key: Int, data: String) {
         (1, "Test")
    }
    
    private var test2: (key: Int, data: String) {
         (2, "Test2")
    }
    
    private var test3: (key: Int, data: String) {
         (1, "Test3")
    }
    
    private let cache: CacheMock = CacheMock()
    
    private func makeSUT() -> Storage<CacheMock> {
        let sut = Storage(provider: cache)
        return sut
    }
}
