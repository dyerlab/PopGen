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
//  GeneticDiversityTests.swift
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

@testable import DLGenetic

import XCTest

class GeneticDiversityTests: XCTestCase {
    
    /*
    func testDefault() throws {
        let diversity = GeneticDiversity.Default()
        XCTAssertEqual(diversity.A, 4)
        XCTAssertEqual(diversity.A95, 4)

        let p = [4.0 / 18.0, 1.0 / 18.0, 8.0 / 18.0, 5.0 / 18.0].map { $0 * $0 }
        let he = 1.0 - p.reduce(0.0, +)
        let ho = 7.0 / 9.0
        let ae = 1.0 / (1.0 - he)

        XCTAssertEqual(diversity.Ho, ho)
        XCTAssertEqual(diversity.He, he)
        XCTAssertEqual(diversity.Ae, ae)
        XCTAssertEqual(diversity.F, 1.0 - ho / he)
    }
     */
    
    func testNullDiversity() {

        let freqs = LocusFrequencies()
        XCTAssertEqual( freqs.alleles.count, 0)
        let diversity = GeneticDiversity(frequencies: freqs )
        XCTAssertEqual(diversity.Ho, 0.0)
        XCTAssertEqual(diversity.He, 0.0)
        XCTAssertEqual(diversity.Ae, 0.0)
        XCTAssertEqual(diversity.F, 0.0)
        
    }
    
    
    func testFreqDescription() throws {
        let diversity = GeneticDiversity.Default()
        let rep = String("\(diversity)")
        XCTAssertTrue( rep.count > 0 )
        
        
    }
    
    
}
