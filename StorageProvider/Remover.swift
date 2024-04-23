//
//  Remover.swift
//  StorageProvider
//
//  Created by Саша Восколович on 07.04.2024.
//

import Foundation

public protocol Remover {
    
    associatedtype Key: Hashable
    associatedtype Element
    
    func remove(byKey key: Key) throws -> Element
}
