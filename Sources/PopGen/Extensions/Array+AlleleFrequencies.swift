//
//  Array+AlleleFrequencies.swift
//  
//
//  Created by Rodney Dyer on 10/30/22.
//

import Foundation
import DLMatrix


extension Array where Element == Frequencies {
        
    public func totalFrequencies() -> Frequencies {
        return Frequencies(freqs: self )
    }
    
    public func totalGeneticDiversity() -> Diversity {
        return Diversity(frequencies: self.totalFrequencies() )
    }
    
    public var allAlleles: [String] {
        var ret = [String]()
        for item in self {
            ret.append( contentsOf: item.alleles )
        }
        return ret.unique().sorted()
    }
    
    public func toMatrix() -> Matrix {
        let alleles = self.allAlleles
        let X = Matrix(count, alleles.count )
        
        X.colNames = alleles
        X.rowNames = self.map{ $0.label }
        for i in 0 ..< self.count {
            for j in 0 ..< alleles.count {
                X[i,j] = self[i].forAllele(allele: alleles[j] )
            }
        }
        
        return X
    }
}
