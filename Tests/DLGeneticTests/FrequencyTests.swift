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
        
        let data = DataStore.Default()
        
        print("Data has \(data.individuals.count) individuals in it")
        print("Data has \(data.frequencies.count) frequencies recorded")
        XCTAssertEqual(data.frequencies.count, 8)
        
        print("LTRS Looks like \(data.getGenotypesFor(locus: "LTRS"))")
        for freq in data.frequencies {
            print("\(freq)")
        }
        
        if let freqs = data.alleleFrequenciesFor(locus: "LTRS") {
            
            
            
            print("\(freqs)")
            
            XCTAssertEqual(freqs.alleles, ["1"])
            XCTAssertEqual(freqs.forAllele(allele: "1"), 1.0)
            XCTAssertEqual(freqs.forAllele(allele: "0"), 0.0)
            XCTAssertEqual(freqs.forAlleles(alleles: ["1", "2"]), [1.0, 0.0])
            XCTAssertEqual(freqs.numHets, 0.0)
            XCTAssertEqual(freqs.numDiploid, 10.0)
        }
    }

    func testInitVariable() throws {
        let data = DataStore.Default()

        XCTAssertEqual(data.frequencies.count, 8)
        if let freqs = data.alleleFrequenciesFor(locus: "MP20") {
            XCTAssertEqual(freqs.alleles, ["5", "7"])
            XCTAssertEqual(freqs.forAllele(allele: "1"), 0.0)
            XCTAssertEqual(freqs.forAllele(allele: "5"), 5.0 / 20.0)
            XCTAssertEqual(freqs.forAllele(allele: "7"), 1.0 - freqs.forAllele(allele: "5"))
            XCTAssertEqual(freqs.forAlleles(alleles: ["5", "7"]), [5.0 / 20.0, 15.0 / 20.0])
            XCTAssertEqual(freqs.numHets, 3.0)
            XCTAssertEqual(freqs.numDiploid, 10.0)
        }
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
        let data = DataStore.Default()
        if let freqs = data.alleleFrequenciesFor(locus: "MP20") {
            let fMat = freqs.asMatrix()
            XCTAssertEqual( fMat.cols, 2)
            XCTAssertEqual( fMat.rows, 1)
            XCTAssertEqual( fMat[0,0], 0.25)
            XCTAssertEqual( fMat[0,1], 0.75)
        }
    }
}
