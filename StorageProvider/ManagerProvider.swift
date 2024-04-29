//
//  ManagerProvider.swift
//  StorageProvider
//
//  Created by Саша Восколович on 28.03.2024.
//

import Foundation


class ManagerProvider<E: StorageProvider & Remover>: StorageProvider {
   
    typealias Key = E.Key
    typealias Element = E.Element
    
    var id: UUID
    private var providers: [E]
    
    
    var providersCount: Int {
        providers.count
    }
    
    
    init(id: UUID = UUID(), providers: E...) {
        self.id = id
        self.providers = providers
    }
    
    
    func save(_ element: Element, forKey key: Key) {
         add(element, forKey: key, to: providers)
    }
    
    func get(by key: Key) -> Element? {
         get(by: key, from: providers)
    }
    
    func get(by key: Key, fromConcrete provider: E) -> Element? {
         get(by: key, from: [provider])
    }
    
    func add(to concreteProvider: E, _ element: Element, forKey key: Key) {
        add(element, forKey: key, to: [concreteProvider])
    }
    
    @discardableResult
    func remove(_ provider: E) -> E? {
        if let index = providers.index(of: provider) {
            return providers.remove(at: index)
        }
        return nil
    }
    
    @discardableResult
    func remove(elementByKey: Key, from provider: E) throws -> Element {
        guard let index = providers.index(of: provider) else {
            throw StorageError.notFound
        }
        return try providers[index].remove(byKey: elementByKey)
    }
    
    
    // MARK: - Helpers
    
    private func add(_ element: Element, forKey key: Key, to providers: [E]) {
        providers.forEach { $0.save(element, forKey: key) }
    }

    
    private func get(by key: Key, from providers: [E]) -> Element? {
        for provider in providers {
            if let element = provider.get(by: key) {
                return element
            }
        }
        return nil
    }
}


enum StorageError: Error {
    case notFound
    
}
extension Array where Element: StorageProvider {
    func index(of element: Element) -> Int? {
        self.firstIndex(where: { $0.id == element.id } )
    }
}
