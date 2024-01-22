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
//  AMOVADistanceTests.swift
//
//
//  Created by Rodney Dyer on 5/13/22.
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

@testable import PopGen

import XCTest
import DLMatrix

class AMOVADistanceTests: XCTestCase {
    func testExample() throws {
        let loci = [Genotype(raw: "A:A"),
                    Genotype(raw: "A:B"),
                    Genotype(raw: "A:C"),
                    Genotype(raw: "B:B"),
                    Genotype(raw: "B:C"),
                    Genotype(raw: "C:C")]

        let M = Matrix(6, 6)
        for i in 0 ..< 6 {
            for j in 0 ..< 6 {
                M[i, j] = amovaDistance(geno1: loci[i], geno2: loci[j])
            }
        }
        M.rowNames = ["AA", "AB", "AC", "BB", "BC", "CC"]
        M.colNames = M.rowNames
        
        let X = Matrix(6,6, [0.0, 1.0, 1.0, 4.0, 3.0, 4.0,
                             1.0, 0.0, 1.0, 1.0, 1.0, 3.0,
                             1.0, 1.0, 0.0, 3.0, 1.0, 1.0,
                             4.0, 1.0, 3.0, 0.0, 1.0, 4.0,
                             3.0, 1.0, 1.0, 1.0, 0.0, 1.0,
                             4.0, 3.0, 1.0, 4.0, 1.0, 0.0])
        X.rowNames = M.rowNames
        X.colNames = M.colNames
        
        XCTAssertEqual( M, X )
        XCTAssertEqual(amovaDistance(geno1: Genotype(raw: "A:B"), geno2: Genotype(raw: "C:D")), 2.0)
    }
}
