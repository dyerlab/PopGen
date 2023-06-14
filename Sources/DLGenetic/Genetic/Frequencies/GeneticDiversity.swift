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
import SwiftUI

public struct GeneticDiversity: Hashable {
    public var locus: String = ""
    public var stratum: String = "x"
    public var N: Int = 0
    public var A: Int = 0
    public var A95: Int = 0
    public var Ae: Double = 0.0
    public var Ho: Double = 0.0
    public var He: Double = 0.0
    public var F: Double = 0.0

    public init() {}

    public init(frequencies: AlleleFrequencies) {
        let alleles = frequencies.alleles
        let freqs = frequencies.frequencies(alleles: alleles)

        stratum = frequencies.stratum
        locus = frequencies.locus 
        N = Int( frequencies.numDiploid )
        A = alleles.count
        A95 = freqs.filter { $0 >= 0.05 }.count

        let p = frequencies.frequencies(alleles: alleles).map { $0 * $0 }
        He = A > 0 ? 1.0 - p.reduce(0.0, +) : 0.0 
        Ho = frequencies.numDiploid > 0 ? frequencies.numHets / frequencies.numDiploid : 0.0
        Ae = A > 0 ? 1.0 / (1.0 - He) : 0.0
        F = He > 0 ? 1.0 - Ho / He : 0.0
    }
    
}



extension GeneticDiversity: CustomStringConvertible {
    /// Override of description for CustomStringConvertible
    public var description: String {
        var ret = "Genetic Diversity for \(stratum): \n"
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
        let freq = AlleleFrequencies.Default()
        let diversity = GeneticDiversity(frequencies: freq)
        return diversity
    }
    
}
