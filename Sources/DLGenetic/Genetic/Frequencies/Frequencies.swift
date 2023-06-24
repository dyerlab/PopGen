//
//  File.swift
//  
//
//  Created by Rodney Dyer on 6/24/23.
//

import Foundation

public class Frequencies {
    
    public var locusFrequencies: [String: AlleleFrequencies]
    
    
    init() {
        locusFrequencies = [String:AlleleFrequencies]()
    }
    
    public func addIndividual( ind: Individual ) {
        for locus in ind.locusNames {
            if let loc = ind.loci[locus] {
                locusFrequencies[locus, default: AlleleFrequencies() ].addGenotype(geno: loc )
            }
        }
    }
    
    
    public func addLocus( name: String, genos: [Genotype] ) {
        locusFrequencies[ name, default: AlleleFrequencies() ].addGenotypes(genos: genos )
    }
}
