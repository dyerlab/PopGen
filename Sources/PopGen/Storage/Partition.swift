//
//  File.swift
//  
//
//  Created by Rodney Dyer on 1/24/24.
//

import Foundation
import SwiftData


/// Partition storage object
///
/// This is the storage object for spatial partitions.
public class Partition: Identifiable {
    
    /// An ID
    public let id: UUID
    
    /// The name of the stratum
    public var level: String
    
    /// The names of the strata
    public var names: [String]
    
    /// Designated initializer
    init(level: String, names: [String]) {
        self.id = UUID()
        self.level = level
        self.names = names
    }
    
    
    
}


extension Partition: CustomStringConvertible {
    
    public var description: String {
        return "\(self.level)\n\(self.names.joined(separator: ", "))\n"
    }
    
}
