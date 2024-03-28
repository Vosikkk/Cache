//
//  Cache.swift
//  Cache
//
//  Created by Саша Восколович on 28.03.2024.
//

import Foundation


protocol Cache {
    
    associatedtype Theme
    associatedtype Game
    
    func get(for theme: Theme) -> Game
    func update(from old: Theme, to new: Theme)
}

