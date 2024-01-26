//
//  Array+AlleleFrequencies.swift
//  
//
//  Created by Rodney Dyer on 10/30/22.
//

import Foundation
import DLMatrix


/// Extensions to general Arrays when they hold ``Genetic/Frequencies/Frequencies`` objects.
extension Array where Element == Frequencies {
        
    /// Create frquencies by coalescing subsets.
    ///
    /// - Returns: A ``Frequencies`` object.
    public func totalFrequencies() -> Frequencies {
        return Frequencies(freqs: self )
    }
    
    /// Estimate total diversity from array of subsets by coalescing individual subdivisions
    ///
    /// - Returns: A ``Diversity`` object.
    public func totalGeneticDiversity() -> Diversity {
        return Diversity(frequencies: self.totalFrequencies() )
    }
    
    /// Get all alleles across all subsets.
    public var allAlleles: [String] {
        var ret = [String]()
        for item in self {
            ret.append( contentsOf: item.alleles )
        }
        return ret.unique().sorted()
    }
    
    /// Create frequency matrix representation
    ///
    /// This takes each element (subset) as a row and estimates allele frequencies for all
    ///  alleles (columns) and returns it as a ``DLMatrix/Matrix`` object.
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
    
    
    
    /// Translate into vector of Allele KeyValueData
    ///
    ///
    public func toKeyValueData(grouped: Bool) -> [KeyValueData] {
        var ret = [KeyValueData]()
        for freq in self {
            for allele in freq.alleles {
                ret.append( KeyValueData( label: grouped ? freq.label : allele,
                                          value: freq.forAllele(allele: allele),
                                          grouping: grouped ? allele : freq.locus ) )
            }
        }
        
        if grouped {
            return ret.sorted(by: { $0.grouping.compare($1.grouping, options: .numeric) == .orderedAscending })
        } else {
            return ret.sorted(by: { $0.label.compare($1.label, options: .numeric) == .orderedAscending })
        }
        

    }
    
}
