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
//  GeneticStudio
//  Genotype.swift
//
//  Created by Rodney Dyer on 05/09/22.
//  Copyright (c) 2021 Rodney J Dyer.  All Rights Reserved.
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


/// A base object to represent a genetic locus.

public struct Genotype: Codable, Equatable, CustomStringConvertible {
    
    /// Keeping the alleles as a diploid set of strings.
    public var left: String = ""
    public var right: String = ""
    
    public var maskedLeft: String {
        return self.masking == .ParentLeft ? "" : self.left
    }
    
    public var maskedRight: String {
        return self.masking == .ParentRight ? "" : self.right
    }

    /// By default
    public var masking: AlleleMasking = .NoMasking

    /// Determines if the genotype is empty
    public var isEmpty: Bool {
        return left.isEmpty && right.isEmpty
    }

    /// Heterozygosity state, must be diploid and alleles are not empty.
    public var isHeterozygote: Bool {
        return ploidy == .Diploid && left != right
    }

    /// Description of the genotype as a string object
    public var description: String {
        switch ploidy {
        case .Missing:
            return "-"
        case .Haploid:
            return String("\(left)\(right)")
        default:
            if masking == .NoMasking || masking == .Undefined {
                return String("\(left):\(right)")
            } else if masking == .ParentLeft {
                return right
            } else if masking == .ParentRight {
                return left
            } else {
                return "XXX"
            }
        }
    }

    /// Ploidy of the current Genotype
    public var ploidy: Ploidy {
        if left.isEmpty && right.isEmpty {
            return .Missing
        } else if left.isEmpty || right.isEmpty {
            return .Haploid
        }
        
        return .Diploid
    }

    /// Default initializer
    public init() {}

    ///  Alleles as array
    public init(alleles: (String, String)) {
        if alleles.0 < alleles.1 {
            left = alleles.0
            right = alleles.1
        } else {
            left = alleles.1
            right = alleles.0
        }
    }

    /// Initializing from string. Alleles separated by ":"
    public init(raw: String) {
        setAlleles(raw: raw)
    }

    /// Equatable means that all alleles are identical
    public static func == (lhs: Genotype, rhs: Genotype) -> Bool {
        return lhs.left == rhs.left && lhs.right == rhs.right
    }

    /// Determines if value can be diploid locus
    public static func canBeGenotype( raw: String ) -> Bool {
        let rawAlleles = raw.components(separatedBy: ":").filter { !$0.isEmpty }
        return rawAlleles.count == 2
    }
    
    /// Sets alleles from raw data with 0 or more alleles separated by colon.
    public mutating func setAlleles(raw: String) {
        let rawAlleles = raw.components(separatedBy: ":").filter { !$0.isEmpty }.sorted(by: { $0.compare($1, options: .numeric) == .orderedAscending })

        if rawAlleles.count == 1 {
            left = rawAlleles[0]
            right = ""
        } else if rawAlleles.count == 2 {
            left = rawAlleles[0]
            right = rawAlleles[1]
        } else {
            left = ""
            right = ""
        }

        // Reset any masking when we reset the allels
        masking = .NoMasking
    }

    public mutating func setMasking(parent: Genotype) {
        if isEmpty || parent.isEmpty {
            masking = .MissingData
        } else if self == parent {
            if isHeterozygote {
                masking = .Undefined
            } else {
                masking = .ParentLeft
            }
        } else if parent.left == right || parent.right == right {
            masking = .ParentRight
        } else if parent.left == left || parent.right == left {
            masking = .ParentLeft
        } else {
            masking = .Undefined
        }
    }

    /// Convert locus to a vector with specific alleles.
    /// - Parameters:
    ///     - alleles: A vector of string objects for all alleles
    /// - Returns: A vector with each allele in the genotype indicated by 1.0.  Returned vector sam length as passed alleles.
    public func asVector(alleles: [String]) -> Vector {
        var ret = Vector(repeating: 0.0, count: alleles.count)
        if !left.isEmpty,
           let idx = alleles.firstIndex(where: { $0 == left })
        {
            ret[idx] = ret[idx] + 1.0
        }
        if !right.isEmpty,
           let idx = alleles.firstIndex(where: { $0 == right })
        {
            ret[idx] = ret[idx] + 1.0
        }
        return ret
    }
}

// MARK: - Operators

public extension Genotype {
    /**
     Random mating of two genotypes.  Both must be diploid
     - Parameters:
      - parent1: First genotype
      - parent2: Second genotype
     - Returns: Random offspring genotype.
     */
    static func + (parent1: Genotype, parent2: Genotype) -> Genotype {
        if parent1.ploidy != .Diploid || parent2.ploidy != .Diploid {
            return Genotype()
        }

        let left = Bool.random() == true ? parent1.left : parent1.right
        let right = Bool.random() == true ? parent2.left : parent2.right

        return Genotype(alleles: (left, right))
    }
}



extension Genotype {
    
    /// Static example of empty locus
    public static func DefaultNULL() -> Genotype {
        return Genotype()
    }

    /// Static example of haploid locus
    public static func DefaultHaploid() -> Genotype {
        return Genotype(raw: "A")
    }

    /// Static example of heterozygote
    public static func DefaultHeterozygote() -> Genotype {
        return Genotype(alleles: ("A", "B"))
    }

    /// Static example of homozygote
    public static func DefaultHomozygote() -> Genotype {
        return Genotype(alleles: ("A", "A"))
    }

    /// Static heterozygote with AlleleMasking.
    public static func DefaultHeterozygoteMomLeft() -> Genotype {
        var geno = Genotype(raw: "A:B")
        geno.masking = .ParentLeft
        return geno
    }

    public static func DefaultHeterozygoteMomRight() -> Genotype {
        var geno = Genotype(raw: "A:B")
        geno.masking = .ParentRight
        return geno
    }

    public static func DefaultHeterozygoteUndefined() -> Genotype {
        var geno = Genotype(raw: "A:B")
        geno.masking = .Undefined
        return geno
    }
}
