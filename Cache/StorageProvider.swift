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
    
    private let providers: [E]
    private var activeProvider: E?
   
    
    init(_ providers: E...) {
        self.providers = providers
    }
    
    func set(active provider: E) {
        self.activeProvider = provider
    }
    
    func save(_ element: Data, addToAllProviders: Bool = false) {
        if addToAllProviders {
            addElement(element, to: providers)
        } else {
            if let providerToUse = providerToUseForSaving() {
                addElement(element, to: [providerToUse])
            } else {
                print("No provider available to save the element.")
            }
        }
    }
    
    private func addElement(_ element: Data, to providers: [E]) {
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
    
    
    private func providerToUseForSaving() -> E? {
        if let activeProvider = activeProvider {
            return activeProvider
        } else if let firstProvider = providers.first {
            return firstProvider
        } else {
            return nil
        }
    }
    
//    func get(_ key: Key) -> Element? {
//         
//    }
}


