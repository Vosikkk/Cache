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
    
    var id: UUID { get }
    func get(by key: Key) -> Element?
    func add(_ element: Element, for key: Key)
}


public protocol Provider {
    
    associatedtype Key: Hashable
    associatedtype Element
    
    var id: UUID { get }
    func get(by key: Key) -> Element?
    func add(_ element: Element, for key: Key)
}


final class ManagerProvider<E: Provider>: Provider {
   
    typealias Key = E.Key
    typealias Element = E.Element
    typealias Data = [Key: Element]
    
    var id: UUID
    
    private let providers: [E]
    private var activeProvider: E?
    
    
    var providersCount: Int {
        providers.count
    }
    
    
    init(id: UUID = UUID(), providers: E...) {
        self.id = id
        self.providers = providers
    }
    
    
    
    
    func get(by key: Key) -> Element? {
        
        return nil
    }
    
    
    
    
    
    func add(_ element: Element, for key: Key) {
         
    }
    
    
    
    
    func save(to concrete: E, _ element: Data) {
        
       
    }
    
    
    
    
    
    
    func set(active provider: E) {
        self.activeProvider = provider
    }
    
    
}
