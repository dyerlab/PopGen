//
//  File.swift
//  
//
//  Created by Rodney Dyer on 1/23/24.
//

import Foundation

/// Locus storage container 
///
/// This is the object that stores a set of genetic data in the
///  main repository. 
public class Locus {
    
    /// ID for Identifiable
    public let id: UUID
    
    /// Name of the locus
    public let name: String
    
    /// Raw genotypes
    ///
    /// When this is changed, it triggers the estimate of allelic and
    ///  genotypic diversity to be restimated.
    public var genotypes: [Genotype] {
        didSet {
            let diversity = Diversity(locus: name, genos: genotypes)
            self.A = diversity.A
            self.Ae = diversity.Ae
            self.He = diversity.He
            self.Ho = diversity.Ho
        }
    }
    
    /// Allelic diversity
    public var Ae: Double = 0.0
    
    /// Number of alleles
    public var A: Int = 0
    
    /// Expected heterozygosity
    public var He: Double = 0.0
    
    /// Observed heterozygosity
    public var Ho: Double = 0.0

    /// Designated initializer
    ///
    /// The main entry point for this locus.  The diversity statistics
    ///  are calculated on initialization, though the diversity and
    ///  frequency objects are not saved.
    ///
    /// - Parameters:
    ///     - name: The name of the locus
    ///     - genotypes: An array of genotypes.
    init(name: String = "", genotypes: [Genotype] ) {
        self.id = UUID()
        self.name = name
        self.genotypes = genotypes
    }
    
}
