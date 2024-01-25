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



extension Partition {
    
    static var defaultMainClade: [Partition] {
        var ret = [Partition]()
        
        let raw = RawData.mainClade
        let levels [ "]
        for i in 0 ..< 2 {
            let
        }
        

        
        return ret
    }
    
}
