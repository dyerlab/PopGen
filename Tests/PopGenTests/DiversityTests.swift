//
//  DiversityTests.swift
//  
//
//  Created by Rodney Dyer on 2024-02-15.
//

@testable import PopGen

import XCTest

final class DiversityTests: XCTestCase {


    
    
    func testDefaultData() throws {
        let div = Diversity.Default()
        
        XCTAssertEqual( div.N, 360 )
        XCTAssertEqual( div.A, 19 )
        XCTAssertEqual( div.A95, 4 )
        XCTAssertEqual( div.Ho, 0.45 )
        
        print("\(div)")
    }
    
    func testInitEmpty() throws {
        let div = Diversity()
        
        XCTAssertEqual( div.N, 0 )
        XCTAssertEqual( div.A, 0 )
        XCTAssertEqual( div.A95, 0 )
        XCTAssertEqual( div.Ae, 0.0 )
        XCTAssertEqual( div.Ho, 0.0 )
        XCTAssertEqual( div.He, 0.0 )
        XCTAssertEqual( div.F, 0.0 )
        
        print("\(div)")
    }
    
    func testInitLocus() throws {
        
        let genotypes = [ Genotype(raw: "A:A"),
                          Genotype(raw: "A:A"),
                          Genotype(raw: "A:B"),
                          Genotype(raw: "B:B") ]
        
        let div = Diversity( locus: "Test",
                             genos: genotypes )
        
        XCTAssertEqual( div.N, 4 )
        XCTAssertEqual( div.A, 2 )
        XCTAssertEqual( div.A95, 2 )
        XCTAssertEqual( div.Ho, 0.25 )
        
        
        let kvData = div.toKeyValueData()
        XCTAssertEqual( kvData.count, 7 )
        let kvData2 = div.toKeyValueData(grouped: true )
        XCTAssertEqual( kvData2.count, 7 )
        
        let A = div.asMatrix()
        XCTAssertEqual( A.rows, 1 )
        XCTAssertEqual( A.cols, 7 )
        
        XCTAssertFalse( div.description.isEmpty )
        
        let freq = Frequencies( locus: "Test",
                                genotypes: genotypes )
        
        let div2 = Diversity( frequencies: freq )
        
        XCTAssertEqual( div.N, div2.N )
        XCTAssertEqual( div.A, div2.A )
        XCTAssertEqual( div.A95, div.A95 )
        XCTAssertEqual( div.Ae, div2.Ae )
        XCTAssertEqual( div.F, div2.F )
        XCTAssertEqual( div.Ho, div2.Ho )
        XCTAssertEqual( div.He, div2.He )
        
        XCTAssertTrue( div == div2 )
    }

    
    func testDefaults() throws {
        let lst = Diversity.DefaultList()
        
        XCTAssertEqual( lst.count, 8 )
    }

}
