//
//  StorageProvider.swift
//  StorageProvider
//
//  Created by Саша Восколович on 07.04.2024.
//

import Foundation

public protocol StorageProvider {
    
    associatedtype Key: Hashable
    associatedtype Element
    
    var id: UUID { get }
    func get(by key: Key) -> Element?
    func save(_ element: Element, forKey key: Key)
}
