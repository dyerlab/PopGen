//
//  File.swift
//  
//
//  Created by Rodney Dyer on 1/25/24.
//

import Foundation

extension Array where Element: Equatable {

    func allIndexes(equalTo item: Element) -> [Int]  {
        return enumerated().compactMap { $0.element == item ? $0.offset : nil }
    }
    
}
