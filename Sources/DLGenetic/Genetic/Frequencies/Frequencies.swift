//
//  File.swift
//  
//
//  Created by Rodney Dyer on 6/24/23.
//

import Foundation

public class Frequencies {
    
    public var locusFrequencies: [String: LocusFrequencies]
    
    public var locusDiversities: [GeneticDiversity] {
        var ret = [GeneticDiversity]()
        for frequency in self.locusFrequencies {
            ret.append( GeneticDiversity( frequencies: frequency.value, locus: frequency.key ) )
        }
        return ret
    }
    
    
    init() {
        locusFrequencies = [String:LocusFrequencies]()
    }
    
    public func addIndividual( ind: Individual ) {
        for locus in ind.locusNames {
            if let loc = ind.loci[locus] {
                locusFrequencies[locus, default: LocusFrequencies() ].addGenotype(geno: loc )
            }
        }
    }
    
    
    public func addLocus( name: String, genos: [Locus] ) {
        locusFrequencies[ name, default: LocusFrequencies() ].addGenotypes(genos: genos )
    }
}



public extension Frequencies {
    
    static var Default: Frequencies {
        return DataStore.Default().frequencies
    }
}
