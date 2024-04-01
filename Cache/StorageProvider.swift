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

