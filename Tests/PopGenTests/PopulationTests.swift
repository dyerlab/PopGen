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
        let coordinates = RawData.DefaultBajaCoordinates
        let loci = RawData.DefaultBajaLoci
        
        let pop = Population(partitions: partitions, coordinates: coordinates, loci: loci)
        
        XCTAssertEqual( pop.count, 361)
        
        print(pop.description)
        
    }


}
