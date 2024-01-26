//
//  PopulationTests.swift
//  
//
//  Created by Rodney Dyer on 1/25/24.
//
@testable import PopGen
import XCTest

final class PopulationTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInit() throws {
        
        let partitions = RawData.DefaultBajaPartitions
        let individuals = RawData.DefaultUnnestedIndividuals
        let pop = Population(individuals: individuals, partitions: partitions )
        
        XCTAssertEqual( pop.count, 365)
        
        print(pop.description)
    }

    
    func testFrequencies() throws {

        let partitions = RawData.DefaultBajaPartitions
        let individuals = RawData.DefaultUnnestedIndividuals
        let pop = Population(individuals: individuals, partitions: partitions )

        let freqs = pop.frequencyForLocus(named: "LTRS")
        print("\(freqs)")
        XCTAssertEqual(freqs.alleles, ["1","2"])
        XCTAssertEqual(freqs.forAllele(allele: "1"), 381.0/730.0)
        XCTAssertEqual(freqs.forAllele(allele: "3"), 0.0)
        XCTAssertEqual(freqs.forAlleles(alleles: ["2", "4"]), [349.0/730.0, 0.0])
        XCTAssertEqual(freqs.numHets, 87.0)
        XCTAssertEqual(freqs.numDiploid, 365.0)
    }

}
