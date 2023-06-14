//
//  Array+AlleleFrequencies.swift
//  
//
//  Created by Rodney Dyer on 10/30/22.
//

import Foundation

extension Array where Element == AlleleFrequencies {
    
    /*
    public func totalDiversity() -> GeneticDiversity {
        var ret = GeneticDiversity()
        
        ret.locus = self.count > 0 ? first!.locus : "undefined"

        ret.N = ret.N + self.compactMap { $0.N }.reduce( 0, +)
        ret.A = ret.A + self.compactMap { $0.A }.reduce( 0, +)
        ret.A95 = ret.A95 + self.compactMap { $0.A95 }.reduce( 0, +)
        ret.Ae = ret.Ae + self.compactMap { $0.Ae }.reduce( 0.0, +)
        ret.Ho = ret.Ho + self.compactMap { $0.Ho }.reduce( 0.0, +)
        ret.He = ret.He + self.compactMap { $0.He }.reduce( 0.0, +)
        ret.F = ret.F + self.compactMap { $0.F }.reduce( 0.0, +)
        
        
        
        return ret
    }
     */
    
    public func totalFrequencies() -> AlleleFrequencies {
        return AlleleFrequencies(freqs: self )
    }
    
    public func totalGeneticDiversity() -> GeneticDiversity {
        return GeneticDiversity(frequencies: self.totalFrequencies() )
    }
    
}
