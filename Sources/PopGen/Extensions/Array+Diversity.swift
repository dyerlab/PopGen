//
//  File.swift
//  
//
//  Created by Rodney Dyer on 1/26/24.
//

import Foundation


/// Extensions to general Arrays when they hold ``Diversity`` objects.
extension Array where Element == Diversity {
    
    /// Extract KVData for diversity parameters
    public var toKVData: [KeyValueData] {
        var ret = [KeyValueData]()
        
        for diversity in self {
            ret.append( contentsOf: diversity.toKeyValueData)
        }
        
        return ret
    }
    
}
