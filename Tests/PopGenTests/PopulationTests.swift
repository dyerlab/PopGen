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

    func testSubpopulations() throws {
        let partitions = RawData.DefaultBajaPartitions
        let individuals = RawData.DefaultUnnestedIndividuals
        let pop = Population(individuals: individuals, partitions: partitions )
        
        let regions = pop.subpopulations(at: "Region")
        XCTAssertEqual( regions.count, 4)
        XCTAssertEqual( regions.map { $0.name}.sorted(), ["CBP","NBP","SBP", "SON"])
        
        let bob = pop.subpopulations(at: "Population")
        XCTAssertEqual( bob.count, 39)
        
        let john = pop.subpopulations(at: "Beetlegeuse")
        XCTAssertEqual( john.count , 0)
        
        let alice = pop.subpopulation(at: "Region", named: "Bob")
        XCTAssertNil( alice )
        
        let son = pop.subpopulation(at: "Region", named: "SON")
        XCTAssertNotNil( son )
        XCTAssertEqual( son?.count ?? 0, 38)
        
        let pop32 = pop.subpopulation(at: "Population", named: "32")
        XCTAssertNotNil( pop32 )
        XCTAssertEqual( pop32?.count ?? 0, 19 )
        
    }

}
