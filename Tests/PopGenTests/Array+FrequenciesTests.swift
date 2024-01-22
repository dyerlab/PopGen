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

    }


}
