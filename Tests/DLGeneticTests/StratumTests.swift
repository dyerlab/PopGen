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
//  StratumTests.swift
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

@testable import DLGenetic

import XCTest
import CoreLocation

class StratumTests: XCTestCase {
    
    func testNULL() throws {
        let stratum = Stratum(name: "Default")
        XCTAssertEqual(stratum.count, 0)
        XCTAssertEqual(stratum.header, [String]())
    }

    func testArapat() throws {
        let data = Stratum.DefaultStratum()
        let headers = ["Population", "Longitude", "Latitude", "AML", "ATPS", "EF", "EN", "LTRS", "MP20", "WNT", "ZMP"]
        XCTAssertEqual(data.count, 10)
        XCTAssertEqual(data.header, headers)

        if let freq = data.frequencies["AML"] {
            print("\(freq)")
        }
    }
    
    
    func testIndices() throws {
        let data = Stratum.DefaultStratum()
        let ind = data[2]
        print("ind: \(ind)")
        XCTAssertEqual( ind.strata["Population"], "88")
    }

    func testInitFamily() throws {
        let mom = Individual()
        mom.loci["Loc1"] = Genotype(raw: "A:A")
        mom.loci["Loc2"] = Genotype(raw: "A:B")

        let family = Stratum(mom: mom, name: "Default")

        let off1 = Individual()
        off1.loci["Loc1"] = Genotype(raw: "A:A")
        off1.loci["Loc2"] = Genotype(raw: "A:B")

        family.addOffspring(offspring: off1)
        XCTAssertEqual( off1.loci["Loc1", default: Genotype()].masking, .MotherLeft )
        XCTAssertEqual( off1.loci["Loc2", default: Genotype()].masking, .Undefined )

    }

    /*
    func testDefaultFamily() throws {
        let data = Stratum.DefaultFamily()
        XCTAssertEqual(data.count, 15)

        XCTAssertEqual(data.frequencies.keys.sorted(), ["cf020", "cf125", "cf213",
                                                        "cf273", "cf581", "cf585",
                                                        "cf597", "cf634", "cf701"])
        if let freq = data.frequencies["cf597"] {
            print("\(freq)")
            XCTAssertEqual(freq.alleles, ["99", "103", "105",
                                          "107", "109", "113",
                                          "115", "117"])
            XCTAssertEqual( freq.frequencies( alleles: ["99", "103", "105",
                                                        "107", "109", "113",
                                                        "115", "117"]),
                           [1.0 / 15.0, 1.0 / 15.0, 3.0 / 15.0,
                            3.0 / 15.0, 1.0 / 15.0, 1.0 / 15.0,
                            4.0 / 15.0, 1.0 / 15.0])
            XCTAssertEqual(freq.numHets, 0.0)
            XCTAssertEqual(freq.numDiploid, 0.0)
        }

        if let freq = data.frequencies["cf125"] {
            print("\(freq)")
            XCTAssertEqual(freq.alleles,
                           ["153", "155", "157"])
            XCTAssertEqual(freq.frequencies(alleles: ["153", "155", "157"]),
                           [9.0 / 23.0, 5.0 / 23.0, 9.0 / 23.0])
            XCTAssertEqual(freq.numHets, 8.0)
            XCTAssertEqual(freq.numDiploid, 8.0)
        } else {
            print("cf125 frequency not estimated.")
        }
    }
     
    
    
    
    func testSpatialFamily() throws {
        
        let data = Stratum.DefaultFamily()
        XCTAssertTrue( data.isFamily )
        let coords = data.coordinates
    
        XCTAssertEqual( coords.count, 1 )
        XCTAssertEqual( coords.first!.latitude, 37.353826)
        XCTAssertEqual( coords.first!.longitude, -77.589796)
        
        
        let locations = data.locations
        XCTAssertEqual( locations.count, 1)
        XCTAssertEqual( locations.first!.name, "1024PWP")
    }

    
    func testSpatialStratum() throws {
        let data = Stratum.DefaultStratum()
        print("The data are: \(data)\n")
        XCTAssertFalse( data.isFamily )
        let coords = data.coordinates
        XCTAssertEqual( coords.count, 10 )
        XCTAssertEqual( coords.first!.latitude, 29.32544972)
        XCTAssertEqual( coords.first!.longitude, -114.2935239)
    }

    */
    
}
