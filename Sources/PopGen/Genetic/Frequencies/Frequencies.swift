//
//  dyerlab.org                                          @dyerlab
//                      _                 _       _
//                   __| |_   _  ___ _ __| | __ _| |__
//                  / _` | | | |/ _ \ '__| |/ _` | '_ \
//                 | (_| | |_| |  __/ |  | | (_| | |_) |
//                  \__,_|\__, |\___|_|  |_|\__,_|_.__/
//                        |_ _/
//
//         Making Population Genetic Software That Doesn't Suck
//
//
//  AlleleFrequencies.swift
//
//
//  Created by Rodney Dyer on 5/9/22.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.

import Foundation
import DLMatrix


/// Allele frequencies object
///
/// This is the main operator for any estimations based upon allele frequencies.
public class Frequencies: Identifiable, Codable {
    /// Identification for object
    public let id: UUID
    
    /// Dictionary for observed genotypes (string representation) and their counts.
    public var genotypes = [String:Double]()
    
    /// Internal counts of all alleles recorded
    private var counts = [String: Double]()
    
    /// The number of actual genotypes evaluated.
    private var N = 0.0
    
    /// The number of observed heterozygotes
    public var numHets = 0.0
    
    /// The number of entered genotypes that were actually diploid
    public var numDiploid = 0.0
    
    /// The locus from which the frequencies are being estimated
    public var locus: String = ""
    
    /// An optional designation for subdivisions to maintain labels
    public var label: String = ""
    
    /// The array of alleles at this locus
    public var alleles: [String] {
        get {
            return counts.keys.sorted { $0.localizedStandardCompare($1) == .orderedAscending }
        }
        set {
            for toAdd in Set(newValue).subtracting(counts.keys) {
                counts[toAdd] = 0.0
            }
        }
    }
    
    /// Return as PieChartDAta
    public var asKeyValueData: [KeyValueData] {
        var ret = [KeyValueData]()
        for allele in self.alleles {
            let data = KeyValueData( label: allele,
                                     value: self.forAllele(allele:  allele ))
            ret.append( data )
        }
        return ret
        
    }
    
    
    /// Convert to `GeneticDiversity` object
    public var asDiversity: Diversity {
        return Diversity(frequencies: self)
    }
    
    /// Property to indicate no genotypes in this object
    public var isEmpty: Bool {
        return self.N == 0
    }

    
    /// Default initializer with option for adding label.
    public init() {
        self.id = UUID()
        self.locus = ""
    }
    
    /// Initializer with array of frequencies to coagulate allele frequencies amongst subgroups.
    public init(freqs: [Frequencies]  ) {
        self.id = UUID()
        self.locus = freqs.first?.locus ?? "No locus given"
        for freq in freqs {
            self.N = self.N + freq.N
            self.numHets = self.numHets + freq.numHets
            self.numDiploid = self.numDiploid + freq.numDiploid
            for allele in freq.alleles {
                self.counts[ allele ] = self.counts[ allele, default: 0.0 ] + freq.counts[ allele, default: 0.0 ]
            }
            for geno in freq.genotypes.keys {
                self.genotypes[ geno ] = self.genotypes[ geno, default: 0.0] + freq.genotypes[ geno, default: 0.0]
            }
        }
    }
    
    
    /// Initialize frequency object with array of genotypes
    public init(locus: String, genotypes: [Genotype] ) {
        self.id = UUID()
        self.locus = locus
        for geno in genotypes {
            addGenotype(geno: geno)
        }
    }

    
    /// Initialize frequency object with array of genotypes
    public init(label: String, locus: String, genotypes: [Genotype] ) {
        self.id = UUID()
        self.locus = locus
        self.label = label 
        for geno in genotypes {
            addGenotype(geno: geno)
        }
    }

    
    
    
    /// Method to add genotype representation to Frequencies
    ///
    /// - Parameters:
    ///     - genos: Array of `Genotype` objects to add to the structure.
    public func addGenotypes(genos: [Genotype]) {
        genos.forEach { geno in
            self.addGenotype(geno: geno)
        }
    }
    
    /// Add individual genotype to struct
    ///
    /// Genotypes should **only** be added to this using this method as this is where all the internal parameters are set.
    /// - Parameters:
    ///     - geno: An object of type `Genotype`
    public func addGenotype(geno: Genotype) {
        
        if !geno.isEmpty && geno.ploidy == .Diploid {
            self.genotypes[ geno.description ] = self.genotypes[ geno.description, default: 0.0] + 1
        }
        
        if geno.ploidy == .Diploid, geno.masking == .NoMasking || geno.masking == .Undefined {
            numDiploid += 1.0
            if geno.isHeterozygote {
                numHets += 1.0
            }
            if !geno.left.isEmpty {
                N += 1.0
                counts[geno.left, default: 0.0] += 1.0
            }
            if !geno.right.isEmpty {
                N += 1.0
                counts[geno.right, default: 0.0] += 1.0
            }
            return
        } else if geno.masking != .NoMasking {
            // either not diploid or masked
            if geno.masking != .ParentLeft && !geno.left.isEmpty {
                N += 1.0
                counts[geno.left, default: 0.0] += 1.0
            }
            if geno.masking != .ParentRight && !geno.right.isEmpty {
                N += 1.0
                counts[geno.right, default: 0.0] += 1.0
            }
        }
    }
    
    /// Returns allele frequency for allele
    ///
    /// - Parameters:
    ///     - allele: The allele inquestion
    /// - Returns: The alllele frequency of the allele (or zero if it is not present)
    public func forAllele(allele: String) -> Double {
        if N == 0.0 {
            return 0.0
        } else {
            return counts[allele, default: 0.0] / N
        }
    }
    
    /// Allele frequencies as vector
    ///
    /// This returns all the alleles, in the same order as asked, as frequencies.
    ///
    /// - Parameters:
    ///     - alleles: An array of alleles being asked for.
    /// - Returns: A vector of allele frequencies from `forAllele()`
    public func forAlleles(alleles: [String]) -> Vector {
        var ret = Vector(repeating: 0.0, count: alleles.count)
        for i in 0 ..< alleles.count {
            ret[i] = forAllele(allele: alleles[i])
        }
        return ret
    }
}

extension Frequencies: CustomStringConvertible {
    
    /// Override of description for textual represntation
    public var description: String {
        var ret = "Frequencies: \(self.locus)\n"
        for allele in alleles {
            ret += String(" \(allele): \(forAllele(allele: allele))\n")
        }
        ret += String("Counts: \(counts)\n")
        ret += String("nHets: \(numHets)\n")
        ret += String("nDip: \(numDiploid)\n")
        ret += String("N: \(N)\n")
        
        ret += String("Genotypes:\n")
        for key in self.genotypes.keys.sorted() {
            ret += String(" \(key): \(self.genotypes[key, default: 0.0])\n")
        }
        return ret
    }
}

public extension Frequencies {
    
    /// Static default version of this object
    static func Default() -> Frequencies {
        let data = DataSet.Default()
        let locus = data.individuals.locusKeys.shuffled().first!
        let genos = data.individuals.getGenotypes(named: locus)
        let freqs = Frequencies(locus: locus, genotypes: genos)
        return freqs
    }
    
    
    /// Static default for list of all allele frequenices
    static func DefaultList() -> [Frequencies] {
        var freqs = [Frequencies]()
        let data = DataSet.Default()
        for locus in data.locusKeys {
            let genos = data.individuals.getGenotypes(named: locus)
            let freq = Frequencies(locus: locus, genotypes: genos)
            freqs.append( freq )
        }
        return freqs
    }
}


extension Frequencies: MatrixConvertible {
    
    /// Conforming to return this object as an Matrix object.
    public func asMatrix() -> Matrix {
        let theAlleles = self.alleles
        let ret = Matrix( 1, theAlleles.count )
        
        ret.colNames = theAlleles
        ret.rowNames = ["All"]
        for i in 0 ..< theAlleles.count {
            ret[0,i] = forAllele(allele: theAlleles[i] )
        }
        return ret
    }
    
    
    
    
}



extension Frequencies: Equatable {
    
    /// Override of equatable operator to determine numerical identity of two `Frequencies` objects
    public static func ==(lhs: Frequencies, rhs:Frequencies ) -> Bool {
        return ( lhs.genotypes == rhs.genotypes &&
                 lhs.counts == rhs.counts  &&
                 lhs.N == rhs.N &&
                 lhs.numHets == rhs.numHets &&
                 lhs.numDiploid == rhs.numDiploid &&
                 lhs.locus == rhs.locus )
    }
}



