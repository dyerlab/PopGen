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


public struct GeneticDiversity: Hashable, Identifiable {
    public var id = UUID()
    public var N: Int = 0
    public var A: Int = 0
    public var A95: Int = 0
    public var Ae: Double = 0.0
    public var Ho: Double = 0.0
    public var He: Double = 0.0
    public var F: Double = 0.0
    public var label: String = ""

    public init() {}

    public init( label: String, genos: [Locus]) {
        self.setParameters( label: label, frequencies: Frequencies(genotypes: genos) )
    }
    
    public init(frequencies: Frequencies ) {
        self.setParameters( label: frequencies.label, frequencies: frequencies )
    }
    
    private mutating func setParameters( label: String, frequencies: Frequencies ) {
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
        self.label = label
    }
    
}


extension GeneticDiversity: MatrixConvertible {
    
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



extension GeneticDiversity: CustomStringConvertible {

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

public extension GeneticDiversity {
    
    static func Default() -> GeneticDiversity {
        let freq = Frequencies.Default()
        let diversity = GeneticDiversity(frequencies: freq )
        return diversity
    }
    
}


extension GeneticDiversity: Equatable {

    public static func ==(lhs:GeneticDiversity, rhs:GeneticDiversity) -> Bool {
        return ( lhs.id == rhs.id &&
                 lhs.N == rhs.N &&
                 lhs.A == rhs.A &&
                 lhs.A95 == rhs.A95 &&
                 lhs.Ae == rhs.Ae &&
                 lhs.Ho == rhs.Ho &&
                 lhs.He == rhs.He &&
                 lhs.F == rhs.F &&
                 lhs.label == rhs.label )
    }
}














