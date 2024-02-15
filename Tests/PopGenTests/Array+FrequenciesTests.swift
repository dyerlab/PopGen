//
//  Array+Frequencies.swift
//  
//
//  Created by Rodney Dyer on 1/22/24.
//

import XCTest
@testable import PopGen

final class Array_FrequenciesTests: XCTestCase {


    func testMatrix() throws {
        
        let genos1 = [ Genotype(alleles: ("A","A")),
                       Genotype(alleles: ("A","A")),
                       Genotype(alleles: ("A","A")),
                       Genotype(alleles: ("A","B")),
                       Genotype(alleles: ("A","B")),
                       Genotype(alleles: ("A","B")),
                       Genotype(alleles: ("B","B"))
                    ]

        let genos2 = [ Genotype(alleles: ("A","A")),
                       Genotype(alleles: ("A","B")),
                       Genotype(alleles: ("A","B")),
                       Genotype(alleles: ("A","B")),
                       Genotype(alleles: ("B","B")),
                       Genotype(alleles: ("B","B")),
                       Genotype(alleles: ("B","B"))
                    ]

        let genos3 = [ Genotype(alleles: ("A","B")),
                       Genotype(alleles: ("A","A")),
                       Genotype(alleles: ("A","A")),
                       Genotype(alleles: ("A","B")),
                       Genotype(alleles: ("B","B")),
                       Genotype(alleles: ("A","B")),
                       Genotype(alleles: ("B","C"))
                    ]

        let freqs = [ Frequencies(label: "Pop1", locus: "LOC-1", genotypes: genos1),
                      Frequencies(label: "Pop2", locus: "LOC-1", genotypes: genos2),
                      Frequencies(label: "Pop3", locus: "LOC-1", genotypes: genos3) ]
        
        let X = freqs.toMatrix()
        
        XCTAssertEqual( X.rows, 3 )
        XCTAssertEqual( X.cols, 3 )
        XCTAssertEqual( X.rowNames, ["Pop1","Pop2","Pop3"] )
        XCTAssertEqual( X.colNames, ["A","B","C"] )
        
        print(X.description)
        
        XCTAssertEqual( X[0,0], freqs[0].forAllele(allele: "A") )
        XCTAssertEqual( X[0,1], freqs[0].forAllele(allele: "B") )
        XCTAssertEqual( X[0,2], freqs[0].forAllele(allele: "C") )
        XCTAssertEqual( X[0,0] + X[0,1] + X[0,2], 1.0 )
        XCTAssertEqual( X[1,0] + X[1,1] + X[1,2], 1.0 )
        XCTAssertEqual( X[2,0] + X[2,1] + X[2,2], 1.0 )
        
        XCTAssertEqual( freqs[0].numHets, 3 )
        XCTAssertEqual( freqs[1].numHets, 3 )
        XCTAssertEqual( freqs[0].numDiploid, 7 )
        XCTAssertEqual( freqs[0].forAllele(allele: "A"), 9.0/14.0 )
        XCTAssertEqual( freqs[0].asDiversity.Ho, 3.0 / 7.0 )
        XCTAssertEqual( freqs[0].asDiversity.He, 1.0 - ( (9.0/14.0 * 9.0/14.0) + (5.0/14.0 * 5.0/14.0) ) )
        
    }

                        

}
