//
//  Cache.swift
//  Cache
//
//  Created by Саша Восколович on 28.03.2024.
//

import Foundation


public protocol StorageProvider {
    
    associatedtype Element
    associatedtype Key: Hashable

    func get(by key: Key) -> Element?
    func add(_ element: Element, for key: Key)
}

final class Storage<E: StorageProvider> {
    
    typealias Element = E.Element
    typealias Key = E.Key
    typealias Data = [Key: Element]
    
    private let provider: E
    
    
    init(provider: E) {
        self.provider = provider
    }
    
    func save(_ element: Data) {
        if let (key, data) = convert(element) {
            provider.add(data, for: key)
        } else {
            fatalError("Oy htere is no data")
        }
    }
    
    private func convert(_ element: Data) -> (Key, Element)? {
        element.map { ($0.key, $0.value) }.first
    }
}


//extension UserDefaults {
//    
//    func themes(forKey key: String) -> [Theme] {
//        if let jsonData = data(forKey: key),
//           let decodedThemes = try? JSONDecoder().decode([Theme].self, from: jsonData) {
//            return decodedThemes
//        } else {
//            return []
//        }
//    }
//    
//    func set(_ themes: [Theme], forKey key: String) {
//        let data = try? JSONEncoder().encode(themes)
//        set(data, forKey: key)
//    }
//}

