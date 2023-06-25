//
//  File.swift
//  
//
//  Created by Rodney Dyer on 6/24/23.
//

import Foundation

public class Frequencies {
    
    public var locusFrequencies: [String: LocusFrequencies]
    
    
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
