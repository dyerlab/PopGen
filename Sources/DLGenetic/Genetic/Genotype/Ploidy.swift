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
//  Ploidy.swift
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

/// An enum to designate ploidy of a locus.
///
/// This is a constant indicator across all instances of a locus, indicating the
///   default ploidy of the locus in the organism.  It conforms to Int and
///   has a rawValue equal to the number of alleles.
public enum Ploidy: Int {
    
    /// No alleles
    case Missing = 0

    /// Only one allele
    case Haploid = 1

    /// Both Alleles present
    case Diploid = 2
    
    /// Three alleles at the locus
    case Triploid = 3
    
    /// Four alleles
    case Polyploid = 4
}
