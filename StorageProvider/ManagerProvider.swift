//
//  ManagerProvider.swift
//  StorageProvider
//
//  Created by Саша Восколович on 28.03.2024.
//

import Foundation


final class ManagerProvider<E: StorageProvider & Remover>: StorageProvider {
   
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
    
    
    func add(_ element: Element, forKey key: Key) {
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
        if let index = index(of: provider) {
            return providers.remove(at: index)
        }
        return nil
    }
    
    @discardableResult
    func remove(elementByKey: Key, from provider: E) -> Element? {
        if let index = index(of: provider) {
           return providers[index].remove(byKey: elementByKey)
        }
        return nil
    }
    
    
    // MARK: - Helpers
    
    private func add(_ element: Element, forKey key: Key, to providers: [E]) {
        providers.forEach { $0.add(element, forKey: key) }
    }

    
    private func get(by key: Key, from providers: [E]) -> Element? {
        for provider in providers {
            if let element = provider.get(by: key) {
                return element
            }
        }
        return nil
    }
    
    
    private func index(of provider: E) -> Int? {
        providers.firstIndex { $0.id == provider.id }
    }
}
