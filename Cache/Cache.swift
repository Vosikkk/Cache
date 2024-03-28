//
//  Cache.swift
//  Cache
//
//  Created by Саша Восколович on 28.03.2024.
//

import Foundation


public protocol Cache {
    
    associatedtype Element: Hashable

    func get(_ element: Element) -> Element?
    func update(_ element: Element)
    func add(_ element: Element)
}

final class Storage<E: Cache> {
    
    typealias Element = E.Element
  
    
    private let cache: E
   
    
    init(cache: E) {
        self.cache = cache
       
    }
    
    func save(_ element: Element) {
        cache.add(element)
    }
    
//    private func isExist(_ element: Element) -> Bool {
//        if let e = cache.get(element) {
//            return e.id == element
//        }
//        return false
//    }
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

