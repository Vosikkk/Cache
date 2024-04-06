//
//  Cache.swift
//  Cache
//
//  Created by Саша Восколович on 28.03.2024.
//

import Foundation


public protocol Provider {
    
    associatedtype Element
    associatedtype Key: Hashable
    
    var id: UUID { get }
    func get(by key: Key) -> Element?
    func add(_ element: Element, for key: Key)
}


public protocol StorageProvider {
    
    associatedtype Key: Hashable
    associatedtype Element
    
    var id: UUID { get }
    func get(by key: Key) -> Element?
    func add(_ element: Element, forKey key: Key)
}


public protocol Remover {
    
    associatedtype E
    
    func remove(_ element: E)
}




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
    
    func remove(_ provider: E) {
        providers.removeAll(where: { $0.id == provider.id })
    }
    
    func remove(_ element: Element, from provider: E) {
         
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
