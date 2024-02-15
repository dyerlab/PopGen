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
//  AMOVADistanceTests.swift
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

@testable import PopGen

import XCTest
import DLMatrix

class AMOVADistanceTests: XCTestCase {
    
    
    func testExample() throws {
        let loci = [Genotype(raw: "A:A"),
                    Genotype(raw: "A:B"),
                    Genotype(raw: "A:C"),
                    Genotype(raw: "B:B"),
                    Genotype(raw: "B:C"),
                    Genotype(raw: "C:C")]

        let M = Matrix(6, 6)
        for i in 0 ..< 6 {
            for j in 0 ..< 6 {
                M[i, j] = amovaDistance(geno1: loci[i], geno2: loci[j])
            }
        }
        M.rowNames = ["AA", "AB", "AC", "BB", "BC", "CC"]
        M.colNames = M.rowNames
        
        let X = Matrix(6,6, [0.0, 1.0, 1.0, 4.0, 3.0, 4.0,
                             1.0, 0.0, 1.0, 1.0, 1.0, 3.0,
                             1.0, 1.0, 0.0, 3.0, 1.0, 1.0,
                             4.0, 1.0, 3.0, 0.0, 1.0, 4.0,
                             3.0, 1.0, 1.0, 1.0, 0.0, 1.0,
                             4.0, 3.0, 1.0, 4.0, 1.0, 0.0])
        X.rowNames = M.rowNames
        X.colNames = M.colNames
        
        XCTAssertEqual( M, X )
        XCTAssertEqual(amovaDistance(geno1: Genotype(raw: "A:B"), geno2: Genotype(raw: "C:D")), 2.0)
        XCTAssertEqual( X.sum, 60.0)
    }
    
    
    func testMissing() throws {
        
        guard let path = Bundle.module.path(forResource: "arapat", ofType: "csv") else {
            print("Could not load path for resource 'arapat.csv'")
            return
        }
        print("Path to CSV: \(path)")
        let reader = CSVReader(path: path)
        
        if let ds = reader.asDataStore() {
         
            let ind1 = ds.individuals[41]
            let ind2 = ds.individuals[42]
            print(ind1)
            print(ind2)
            
            var ctr = 0.0
            for locus in ind1.locusNames {
                let g1 = ind1.loci[locus, default: Genotype()]
                let g2 = ind2.loci[locus, default: Genotype()]
                                   
            
                let dist = amovaDistance( geno1: g1,
                                          geno2: g2)
                ctr += dist
                print( "\(locus): \(g1) <-> \(g2) = \(dist) : \(ctr)")
            }
            
        }
        
        
        
    }
    
    
    
    
    func testArapat() throws {
        
        guard let path = Bundle.module.path(forResource: "arapat", ofType: "csv") else {
            print("Could not load path for resource 'arapat.csv'")
            return
        }
        print("Path to CSV: \(path)")
        let reader = CSVReader(path: path)
        
        if let ds = reader.asDataStore() {
            
            var ids = Array(ds.individuals[ 0 ... 9] )
            
            for ind in ids {
                print(ind)
            }
            var D = amovaDistance(individuals: ids)
            print(D)
            print(D.sum)
            XCTAssertEqual( D.sum, 466.0)
            
            
            ids = Array(ds.individuals[ 41 ... 46] )
            D = amovaDistance(individuals: ids)
            print(D)
            print(D.sum)
            XCTAssertEqual( D.sum, 220.0)
        }
        
        /*
         
         library( gstudio )
         path <- "path to arapat.csv"
         data <- read_population(path, locus.columns=7:14, type="separated" )
         D <- dist_amova( x=data )
         
         D[1:10,1:10]
         sum(D[1:10,1:10])
         
         
         
        # 41 ... 46 in Swift
        seq <- 42:47
        D[seq,seq]
              [,1] [,2] [,3] [,4] [,5] [,6]
         [1,]    0    9   10   13    7   13
         [2,]    9    0    5    8    8    4
         [3,]   10    5    0    1    7    5
         [4,]   13    8    1    0    8    4
         [5,]    7    8    7    8    0    8
         [6,]   13    4    5    4    8    0
         
         */
        
    }
    
}
