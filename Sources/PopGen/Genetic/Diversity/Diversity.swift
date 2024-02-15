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
//  GeneticDiversity.swift
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
import SwiftUI


/// A general struct that contains a host of derived diversity structures.
///
/// This is a general summary object that is intstantiated by either a set of genotypes or a frequency array that estimates common measures of genetic diversity.
public struct Diversity: Hashable, Identifiable {
    
    /// Unique id
    public var id = UUID()
    
    /// The total number of genotypes used to estimate the parameters.
    public var N: Int = 0
    
    /// The raw number of alleles present.
    public var A: Int = 0
    
    /// The alleles with a frequency of 5% or better
    public var A95: Int = 0
    
    /// The effective (frequency weighed) number of alleles at the locus.
    public var Ae: Double = 0.0
    
    /// The observed heterozygosity (if diploid) of the genotypes.
    public var Ho: Double = 0.0
    
    /// The exected heterozygosity at the locus based upon allele frequencies
    public var He: Double = 0.0
    
    /// The proportional reduction in heterozygosity.
    public var F: Double = 0.0
    
    /// The label for the object.  This is where you'd put in the stratum name so when it is displayed, the stratum can be properly labeled.
    public var label: String = ""
    
    /// The name of the locus being examined.
    public var locus: String = ""
    
    /// Default init with no data.
    public init() {}
    
    /// Initializer with label and locus
    ///
    /// - Parameters:
    ///     - locus: The name of the locus being examined.
    ///     - genos: An array of `Genotype` objects to estimate parameters from.
    public init(locus: String, genos: [Genotype]) {
        self.setParameters(frequencies: Frequencies(label: "", locus: locus, genotypes: genos) )
    }
    
    /// Initializer from allele frequency object
    ///
    /// - Parameters:
    ///     - frequencies: A `Frequencies` object rom which to extract the parameters from.
    public init(frequencies: Frequencies ) {
        self.setParameters(frequencies: frequencies )
    }
    
    
    /// Default chokepoint through which all labels are set.
    private mutating func setParameters(frequencies: Frequencies ) {
        let alleles = frequencies.alleles
        let freqs = frequencies.forAlleles(alleles: alleles)
        N = Int( frequencies.numDiploid )
        A = alleles.count
        A95 = freqs.filter { $0 >= 0.05 }.count
        let p = frequencies.forAlleles(alleles: alleles).map { $0 * $0 }
        He = A > 0 ? 1.0 - p.reduce(0.0, +) : 0.0
        Ho = frequencies.numDiploid > 0 ? frequencies.numHets / frequencies.numDiploid : 0.0
        Ae = A > 0 ? 1.0 / (1.0 - He) : 0.0
        F = He > 0 ? 1.0 - Ho / He : 0.0
        self.locus = frequencies.locus
        self.label = frequencies.label
    }
    
    
    public func toKeyValueData( grouped: Bool = false  ) -> [KeyValueData] {
        var ret = [KeyValueData]()
        if grouped {
            ret.append( KeyValueData(label: self.label, value: N, grouping: "N"))
            ret.append( KeyValueData(label: self.label, value: A, grouping: "A" ) )
            ret.append( KeyValueData(label: self.label, value: A95, grouping: "A95" ) )
            ret.append( KeyValueData(label: self.label, value: Ae, grouping: "Ae" ) )
            ret.append( KeyValueData(label: self.label, value: Ho, grouping: "Ho") )
            ret.append( KeyValueData(label: self.label, value: He, grouping: "He") )
            ret.append( KeyValueData(label: self.label, value: F, grouping: "F") )
        } else {
            ret.append( KeyValueData(label: "N", value: N, grouping: self.locus))
            ret.append( KeyValueData(label: "A", value: A, grouping: self.locus) )
            ret.append( KeyValueData(label: "A95", value: A95, grouping: self.locus) )
            ret.append( KeyValueData(label: "Ae", value: Ae, grouping: self.locus) )
            ret.append( KeyValueData(label: "Ho", value: Ho, grouping: self.locus) )
            ret.append( KeyValueData(label: "He", value: He, grouping: self.locus) )
            ret.append( KeyValueData(label: "F", value: F, grouping: self.locus) )
        }
        return ret
    }
    
}


extension Diversity: MatrixConvertible {
    
    /// Parameters in matrix format.
    /// - Returns: Returns values as a matix with 1 row and 7 columns.
    public func asMatrix() -> DLMatrix.Matrix {
        let ret = Matrix(1,7,0.0)
        ret.rowNames = [label]
        ret[0,0] = Double(N)
        ret[0,1] = Double(A)
        ret[0,2] = Double(A95)
        ret[0,3] = Ae
        ret[0,4] = Ho
        ret[0,5] = He
        ret[0,6] = F
        return ret
    }
    
}





extension Diversity: CustomStringConvertible {
    
    /// Override of description for CustomStringConvertible
    public var description: String {
        var ret = "Genetic Diversity: \(label)\n"
        ret += String("N: \(N)\n")
        ret += String("A: \(A)\n")
        ret += String("A95: \(A95)\n")
        ret += String("Ae: \(Ae)\n")
        ret += String("Ho: \(Ho)\n")
        ret += String("He: \(He)\n")
        ret += String("F: \(F)\n")
        return (ret)
    }
}

public extension Diversity {
    
    /// Creates a default GeneticDiversity Object for testing.
    /// - Returns: A default `GeneticDiversity` object with default parameters.
    static func Default() -> Diversity {
        let freq = Frequencies.Default()
        let diversity = Diversity(frequencies: freq )
        return diversity
    }
    
    /// Create list of several loci with diversity values from default data
    /// - Returns: An array of `GeneticDiversity` objects.
    static func DefaultList() -> [Diversity] {
        var ret = [Diversity]()
        
        for freq in Frequencies.DefaultList() {
            ret.append( Diversity(frequencies: freq) )
        }
        
        return ret
    }
    
}


extension Diversity: Equatable {
    
    /// Override equality operator that assumes all instance variables are identical.
    public static func ==(lhs:Diversity, rhs:Diversity) -> Bool {
        return ( lhs.N == rhs.N &&
                 lhs.A == rhs.A &&
                 lhs.A95 == rhs.A95 &&
                 lhs.Ae == rhs.Ae &&
                 lhs.Ho == rhs.Ho &&
                 lhs.He == rhs.He &&
                 lhs.F == rhs.F &&
                 lhs.label == rhs.label )
    }
}















