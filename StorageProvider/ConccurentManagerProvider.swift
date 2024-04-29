//
//  ConccurentManagerProvider.swift
//  StorageProvider
//
//  Created by Саша Восколович on 29.04.2024.
//

import Foundation



class ConcurrentManagerProvider<E: StorageProvider> where E: Remover {
    
    typealias Key = E.Key
    typealias Element = E.Element
    
    private let providersStorage: StorageForProviders<E>
    
    
    init(providers: E...) {
        self.providersStorage = .init(providers: providers)
    }
    
    
    func get(by key: Key) async throws -> Element {
        try await providersStorage.get(by: key)
    }
    
    func save(_ element: Element, forKey key: Key) async throws {
        try await providersStorage.save(element, forKey: key)
    }
    
    func get(by key: Key, fromConcrete provider: E) async throws -> Element {
        try await providersStorage.get(by: key, fromConcrete: provider)
    }
    
    func remove(_ provider: E) async throws -> E {
        try await providersStorage.remove(provider)
    }
    
    func remove(byKey key: Key, from provider: E) async throws -> Element {
        try await providersStorage.remove(byKey: key, from: provider)
    }
}


private actor StorageForProviders<E: StorageProvider> where E: Remover {
    
    typealias Key = E.Key
    typealias Element = E.Element
    
    private var providers: [E]

    init(providers: [E]) {
        self.providers = providers
    }
    
    func save(_ data: Element, forKey key: Key) throws {
        providers.forEach { $0.save(data, forKey: key) }
    }
    
    func get(by key: Key) throws -> Element {
        try get(by: key, from: providers)
    }
    
    
    func get(by key: Key, fromConcrete provider: E) throws -> Element {
        try get(by: key, from: [provider])
    }
    
    func remove(_ provider: E) throws -> E {
        if let index = providers.index(of: provider) {
            return providers.remove(at: index)
        }
        throw StorageError.notFound
    }
    
    func remove(byKey key: Key, from provider: E) throws -> Element {
        if let index = providers.index(of: provider) {
            return try providers[index].remove(byKey: key)
        }
        throw StorageError.notFound
    }
    
    
    
    private func get(by key: Key, from providers: [E]) throws -> Element {
        for provider in providers {
            if let element = provider.get(by: key) {
                return element
            }
        }
        throw StorageError.notFound
    }
}
