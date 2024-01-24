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
@Model public class Partition {
    
    /// An ID
    let id: UUID
    
    /// The name of the stratum
    var name: String
    
    /// The names of the strata
    var levels: [String]
    
    /// Designated initializer
    init(name: String, levels: [String]) {
        self.id = UUID()
        self.name = name
        self.levels = levels
    }
}
