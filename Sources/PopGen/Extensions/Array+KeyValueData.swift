//
//  File.swift
//
//
//  Created by Rodney Dyer on 1/26/24.
//

import Foundation

extension Array where Element == KeyValueData {
    
    /// Export data to R text and copy
    public func asRData(named: String) -> String {
        
        let labels = self.map{ String("'\($0.label)'") }
        let values = self.map{ String("\($0.value)") }
        let groupings = self.map{ String("'\($0.grouping)'") }
        
        var res = String("\(named) <- data.frame(\n")
        res += String("  labels = c(\(labels.joined(separator: ", "))),\n")
        res += String("  values = c(\(values.joined(separator: ", "))),\n")
        res += String("  groupings = c(\(groupings.joined(separator: ", ")))\n)\n")
        return res
    }
    
    
}

