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
    public func toKeyValueData( grouped: Bool) -> [KeyValueData] {
        var ret = [KeyValueData]()
        for diversity in self {
            ret.append( contentsOf: diversity.toKeyValueData(grouped: grouped) )
        }
        return ret
    }
    
}
