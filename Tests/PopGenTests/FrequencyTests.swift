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

@testable import PopGen

import XCTest

class FrequencyTests: XCTestCase {
    
    func testInitFixed() throws {
        let data = DataSet.Default()
        XCTAssertEqual(data.frequencies.count, 8)
        
        let freqs = data.alleleFrequenciesFor(locus: "LTRS")
        print("\(freqs)")
        XCTAssertEqual(freqs.alleles, ["1","2"])
        XCTAssertEqual(freqs.forAllele(allele: "1"), 381.0/730.0)
        XCTAssertEqual(freqs.forAllele(allele: "3"), 0.0)
        XCTAssertEqual(freqs.forAlleles(alleles: ["2", "4"]), [349.0/730.0, 0.0])
        XCTAssertEqual(freqs.numHets, 87.0)
        XCTAssertEqual(freqs.numDiploid, 365.0)
    }
    
    
    func testMatrix() throws {
        let freq = Frequencies.Default()
        let F = freq.asMatrix()
        XCTAssertEqual( F.rows, 1  )
        XCTAssertEqual( F.cols, 19 )
        print("\(F)")
    }

    
    func testFreqInits() throws {
        let freq = Frequencies(freqs: [ Frequencies.Default(), Frequencies.Default() ] )
        XCTAssertEqual( freq.numDiploid, 720.0 )
    }
    
    
    func testFreqs() throws {
        let freq2 = Frequencies.DefaultList()
        if let f2 = freq2.first(where: { $0.locus == "MP20" } ) {
            XCTAssertTrue( Frequencies.Default() == f2 )
        }
    }
    
    
    func testAddLocus() throws {
        let freq = Frequencies.Default()
        let Nhet = freq.numHets
        let Ndip = freq.numDiploid
        
        freq.addGenotype(geno: Genotype(raw: "1:2") )
        XCTAssertEqual( freq.numHets, (Nhet + 1) )
        XCTAssertEqual( freq.numDiploid, (Ndip + 1) )
        XCTAssertFalse( freq.isEmpty )
        
        XCTAssertEqual( freq.alleles,
                        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19"] )
    }
    
    
    func testKVConversion() throws {
        
        let freq = Frequencies.Default()
        let kvData = freq.asKeyValueData
        XCTAssertEqual( kvData.count, 19 )
    }
    
    
}

