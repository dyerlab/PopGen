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
//  FrequencyTests.swift
//
//
//  Created by Rodney Dyer on 5/12/22.
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

class FrequencyTests: XCTestCase {
    func testInitFixed() throws {
        let data = Stratum.DefaultStratum()

        XCTAssertEqual(data.frequencies.count, 8)
        let freqs = data.frequencies["LTRS", default: AlleleFrequencies()]
        XCTAssertEqual(freqs.alleles, ["1"])
        XCTAssertEqual(freqs.frequency(allele: "1"), 1.0)
        XCTAssertEqual(freqs.frequency(allele: "0"), 0.0)
        XCTAssertEqual(freqs.frequencies(alleles: ["1", "2"]), [1.0, 0.0])
        XCTAssertEqual(freqs.numHets, 0.0)
        XCTAssertEqual(freqs.numDiploid, 10.0)
        print("Fixed:\n\(freqs)")
    }

    func testInitVariable() throws {
        let data = Stratum.DefaultStratum()

        XCTAssertEqual(data.frequencies.count, 8)
        let freqs = data.frequencies["MP20", default: AlleleFrequencies()]
        XCTAssertEqual(freqs.alleles, ["5", "7"])
        XCTAssertEqual(freqs.frequency(allele: "1"), 0.0)
        XCTAssertEqual(freqs.frequency(allele: "5"), 5.0 / 20.0)
        XCTAssertEqual(freqs.frequency(allele: "7"), 1.0 - freqs.frequency(allele: "5"))
        XCTAssertEqual(freqs.frequencies(alleles: ["5", "7"]), [5.0 / 20.0, 15.0 / 20.0])
        XCTAssertEqual(freqs.numHets, 3.0)
        XCTAssertEqual(freqs.numDiploid, 10.0)
        print("Variable:\n\(freqs)")
    }

    /*
    func testInitFamily() throws {
        let data = Stratum.DefaultFamily()

        print("Family:\n\(data)")
        XCTAssertEqual(data.frequencies.count, 9)

        if let freqs = data.frequencies["cf020"] {
            print("Pollen Frequencies:\n\(freqs)")
        } else {
            print("no frequencies")
        }
    }
     */
    
    
    func testMatrix() throws {
        let data = Stratum.DefaultStratum()
        let freqs = data.frequencies["MP20", default: AlleleFrequencies()]
        let fMat = freqs.asMatrix()
        XCTAssertEqual( fMat.cols, 2)
        XCTAssertEqual( fMat.rows, 1)
        XCTAssertEqual( fMat[0,0], 0.25)
        XCTAssertEqual( fMat[0,1], 0.75)
    }
}
