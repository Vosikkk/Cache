//
//  Storage.swift
//  Cache
//
//  Created by Саша Восколович on 02.04.2024.
//

import Foundation

final class Storage<E: Provider> {
    
    typealias Element = E.Element
    typealias Key = E.Key
    typealias Data = [Key: Element]
    
    private let providers: [E]
    private var activeProvider: E?
   
    
    init(_ providers: E...) {
        self.providers = providers
    }
    
    func set(active provider: E) {
        self.activeProvider = provider
    }
    
    func save(_ element: Data, to concrete: E? = nil, addToAllProviders: Bool = false) {
        if concrete != nil, addToAllProviders {
            print("Error: 'concrete' and 'addToAllProviders' parameters cannot be set simultaneously.")
            return
        }
        if let providerToUse = whichAdd(concrete: concrete, addToAllProviders: addToAllProviders) {
            add(element, to: providerToUse)
        }
        return
    }
    
    func get(_ key: Key, from provider: E) -> Element? {
        if let index = index(of: provider) {
            return providers[index].get(by: key)
        } else {
            return nil
        }
    }
    
    
    private func add(_ element: Data, to providers: [E]) {
        if let convertedElement = convert(element) {
            providers.forEach { $0.add(convertedElement.1, for: convertedElement.0) }
        } else {
            print("Failed to convert element.")
        }
    }
    
    
    private func convert(_ element: Data) -> (Key, Element)? {
        guard let firstElement = element.first else {
            return nil
        }
        return (firstElement.key, firstElement.value)
    }
    
    
    private func whichAdd(concrete: E?, addToAllProviders: Bool) -> [E]? {
        let res: [E]
        if addToAllProviders {
            res = providers
        } else if let concreteProvider = concrete {
            res = [concreteProvider]
        } else if let provider = providerToUseForSaving() {
            res = [provider]
        } else {
            print("No provider available to save the element.")
            return nil
        }
        return res
    }
    
    private func providerToUseForSaving() -> E? {
        if let activeProvider = activeProvider {
            return activeProvider
        } else {
            return providers.first
        }
    }
    
    private func index(of provider: E) -> Int? {
        providers.firstIndex { $0.id == provider.id }
    }
}


