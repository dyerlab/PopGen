//
//  Array+IndividualTests.swift
//  
//
//  Created by Rodney Dyer on 7/4/23.
//
@testable import PopGen
import XCTest

final class Array_IndividualTests: XCTestCase {

    func testExample() throws {
        let inds = DataSet.Default().individuals
        
        XCTAssertEqual( inds.locusKeys,
                        ["AML", "ATPS", "EF", "EN", "LTRS", "MP20", "WNT", "ZMP"] )
        XCTAssertEqual( inds.strataKeys, ["Population","Region"] )
        
        XCTAssertTrue( inds.isSpatial )
        XCTAssertFalse( inds.isEmpty )
        
        let cts = inds.strataCounts
        XCTAssertEqual( cts["Region"], 4)
        XCTAssertEqual( cts["Population"], 39)
        
        XCTAssertEqual( inds.strataLevels(within: "Region").sorted(), ["CBP", "NBP", "SBP", "SON"] )
        
        XCTAssertEqual( inds.individualsForStratumLevel(stratumName: "Region", stratumLevel: "SON").count, 38)
        XCTAssertEqual( inds.individualsForStratumLevel(stratumName: "Population", stratumLevel: "Aqu").count, 8)
        
        let indsSBP98 = inds.individualsForStratumLevel(stratumName: "Population", stratumLevel: "98")
        XCTAssertEqual( indsSBP98.count, 4 )

        
        let indsLTRS = inds.locusForStrataLevels(locus: "LTRS", stratumName: "Region")
        XCTAssertEqual( Array<String>(indsLTRS.keys).sorted(), ["CBP", "NBP", "SBP", "SON"])
        XCTAssertEqual( indsLTRS.keys.count, 4)
        XCTAssertEqual( indsLTRS["SON"]!.count, 38)
        
        let divLTRS = inds.diversityByStrataLevel(locus: "LTRS", stratumName: "Region")
        XCTAssertEqual( divLTRS.count, 4)
        
        if let SON = divLTRS.first(where: {$0.label == "SON"} ){
            print("SONORAN Diversity: \n \(SON.description)")
        }

    }

}
