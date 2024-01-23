//
//  File.swift
//  
//
//  Created by Rodney Dyer on 1/23/24.
//

import Foundation

/// Working on storage option for data sets.
class Locus {
    let id: UUID
    let name: String
    var genotypes: [Genotype]

    var frequencies: Frequencies {
        return Frequencies( locus: self.name,
                            genotypes: self.genotypes )
    }
    
    var diversity: Diversity {
        return Diversity( frequencies: self.frequencies )
    }
    
    init(name: String = "", genotypes: [Genotype] ) {
        self.id = UUID()
        self.name = name
        self.genotypes = genotypes
    }
    
}
