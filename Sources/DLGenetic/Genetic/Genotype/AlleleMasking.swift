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
//  AlleleMasking.swift
//
//
//  Created by Rodney Dyer on 5/10/22.
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

/// An enum to idicate the masking level for genotypes in family arrays
///   or other parent/offspring kinds of relationships.
///
/// Allele masking is the way that parent/offspring relationships are
///   displayed and manipulated with.  For example, if you would like
///   to estimate pollen pool allele frequencies, you need to remover the
///   maternal contribution and then pass the set of loci to Frequencies
///   objects.  The locus is not internally modified, **but** with masking
///   the receiving Frequency object knows which allele to consider in
///   isolation.
public enum AlleleMasking: String, Codable {
    /// No masking
    case NoMasking = "No Masking"

    /// Mother has left allele
    case ParentLeft = "Parent Allele Left"

    /// Mother is right allele
    case ParentRight = "Parent Allele Right"

    /// Cannot determine masking due to shared heterozygote
    case Undefined = "Parent/Offpsring Same Heterozygote"

    /// Missing data
    case MissingData = "Missing Data"
}
