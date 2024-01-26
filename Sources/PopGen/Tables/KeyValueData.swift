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
    public let grouping: String
    
    init(label: String, value: Double, grouping: String = "") {
        self.id = UUID()
        self.label = label
        self.value = value
        self.asDouble = true 
        self.grouping = grouping
    }
    
    init(label: String, value: Int, grouping: String = "") {
        self.id = UUID()
        self.label = label
        self.value = Double(value)
        self.asDouble = false
        self.grouping = grouping 
    }
    
    
}
