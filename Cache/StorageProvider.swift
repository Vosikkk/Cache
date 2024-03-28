//
//  Cache.swift
//  Cache
//
//  Created by Саша Восколович on 28.03.2024.
//

import Foundation


public protocol StorageProvider {
    
    associatedtype Element
    associatedtype Key

    func get(by key: Key) -> Element?
    func update(for key: Key, new element: Element)
    func add(_ element: (key: Key, data: Element))
}

final class Storage<E: StorageProvider> {
    
    typealias Element = E.Element
    typealias Key = E.Key
    typealias Data = (key: Key, data: Element)
    
    private let provider: E
    
    
    init(provider: E) {
        self.provider = provider
    }
    
    func save(_ element: Data) {
        provider.add(element)
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

