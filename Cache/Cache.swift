//
//  Cache.swift
//  Cache
//
//  Created by Саша Восколович on 28.03.2024.
//

import Foundation


protocol Cache {
    
    associatedtype Element
    
    func get(_ element: Element) -> Element
    func update(from old: Element, to new: Element)
    func add(_ element: Element)
}


