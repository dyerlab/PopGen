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
//  DataStoreTests.swift
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
//

@testable import PopGen
import XCTest

class DataStoreTests: XCTestCase {

    
    func testInit() throws {
        let ds = DataSet()
        
        XCTAssertTrue( ds.isEmpty )
        
        let genos = [ Genotype(raw: "A:A"),
                      Genotype(raw: "A:A"),
                      Genotype(raw: "A:A"),
                      Genotype(raw: "A:B"),
                      Genotype(raw: "B:B")
                    ]
        
        for geno in genos {
            let ind = Individual()
            ind.loci["ATP"] = geno
            ds.addIndividual(ind: ind)
        }

        XCTAssertFalse( ds.isEmpty )
        XCTAssertEqual( ds.count, 5 )
        XCTAssertEqual( ds.frequencies.count, 1)
        print("\(ds)")
        print("\(ds.frequencies.first!)")
        
        
    }
    
    func testIndividualsAtLevel() throws {
        let ds = DataSet.Default()
        let inds = ds.individualsAtLevel(stratum: "Region", level: "SON")
        XCTAssertEqual( inds.count, 38)
    }
    
    
    func testDataStoreForLevel() throws {
        let ds = DataSet.Default()
        let son = ds.dataStoreForLevel(stratum: "Region", level: "SON")
        print(son)
        XCTAssertEqual( son.count, 38)
        let inds = ds.individualsAtLevel(stratum: "Region", level: "SON")
        XCTAssertEqual( inds.count, 38)
        let son1 = DataSet(individuals: inds )
        XCTAssertEqual( son1.count, 38)
        
    }
    
    
    
    func testPartitions() throws {
        let ds = DataSet.Default()
        let partitions = ds.partition(strata: "Region")
        XCTAssertEqual( partitions.count, 4 )
    }
    
    
    func testGenotypeGrabAndFrequencies() throws {
        let ds = DataSet.Default()
        let genos = ds.genotypesFor(locus: "LTRS" )
        let freq = Frequencies(locus: "LTRS", genotypes: genos)
        let dsFreqs = ds.frequencies.first(where: {$0.locus == "LTRS"} ) ?? Frequencies()
        XCTAssertEqual( freq, dsFreqs )
        XCTAssertEqual( freq, ds.alleleFrequenciesFor(locus: "LTRS"))
    }
    
    func testGenotypeDiversityStuff() throws {
        let ds = DataSet.Default()
        let divs = ds.diversityForAllLoci()
        XCTAssertEqual( divs.count, 8)
        
    }
    
    
    func testFrequenciesForStrataAtLocus() throws {
        let ds = DataSet.Default()
        let ltrs = ds.frequencyForStrataLevels(locus: "LTRS", strata: "Region")
        XCTAssertEqual( ltrs.count, 4 )
        for ltr in ltrs { print(ltr) }
    }
    
    func testDiversityForStrataAtLocus() throws {
        let ds = DataSet.Default()
        let ltrs = ds.diversityForStratLevels(locus: "LTRS", strata: "Region")
        XCTAssertEqual( ltrs.count, 4 )
        for ltr in ltrs { print(ltr) }
    }

    
    
    /*
    
    func testNoStratum() throws {
        let data = DataStore()
        let stratum = data.getStratum(named: "Bob")
        XCTAssertTrue( stratum.isEmpty )
    }

    func testExample() throws {
        
        let data = DataStore.Default()
        
        XCTAssertEqual( data.numInds, 365 )
        XCTAssertEqual( data.count, 39 )
        
        
        XCTAssertEqual( data.strataKeys, ["9", "12", "32", "48",
                                          "51", "58", "64", "73",
                                          "75", "77", "84", "88",
                                          "89", "93", "98", "101",
                                          "102", "153", "156", "157",
                                          "159", "160", "161", "162",
                                          "163", "164", "165", "166",
                                          "168", "169", "171", "173",
                                          "175", "177", "Aqu", "Const",
                                          "ESan", "Mat", "SFr"])
        XCTAssertEqual( data.locusKeys, ["AML", "ATPS", "EF", "EN",
                                         "LTRS", "MP20", "WNT", "ZMP"] )
    }
    
    
    func testFrequencies() throws {
        let data = DataStore.Default()
        XCTAssertEqual( data.count, 39 )
        XCTAssertEqual( data.numInds, 365 )
        XCTAssertFalse( data.isEmpty )
        
        let missingFreq = data.allFrequencysFor(locus: "bob")
        XCTAssertTrue( missingFreq.isEmpty)
        
        let fLTRS = data.allFrequencysFor(locus: "LTRS")
        print("\(fLTRS)")
        XCTAssertEqual( fLTRS.alleles, ["1","2"])
        XCTAssertEqual( fLTRS.frequency(allele: "1"), 381.0 / 730.0 )
    }
    
    func testFrequencyMatrix() throws {
        let data = DataStore.Default()
        XCTAssertEqual( data.count, 39 )
        let fMat = data.allFrequencyMatrixFor(locus: "LTRS")
        XCTAssertEqual( data.count, fMat.rows)
        XCTAssertEqual( fMat.colNames, ["1","2"])
    }
    
    
     
    func testGenotypeMatix() throws {
        let data = DataStore.Default()
        let gMat = data.genotypeMatrixFor(locus: "LTRS")
        XCTAssertEqual( data.count, gMat.rows)
        XCTAssertEqual( gMat.colNames, ["1:1","1:2","2:2"])
        print("\(gMat)")
    }
     */

    

    
}
