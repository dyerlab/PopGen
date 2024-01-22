//
//  File.swift
//  
//
//  Created by Rodney Dyer on 1/22/24.
//

import Foundation

/// Generic structure for getting 2-column data into a table object
public struct KeyValueData: Identifiable {
    public let id: UUID
    public let label: String
    public let value: Double
    public let asDouble: Bool
    
    init(label: String, value: Double) {
        self.id = UUID()
        self.label = label
        self.value = value
        self.asDouble = true 
    }
    
    init(label: String, value: Int) {
        self.id = UUID()
        self.label = label
        self.value = Double(value)
        self.asDouble = false
    }
    
}
