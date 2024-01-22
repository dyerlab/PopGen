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
//  GenotypeTests.swift
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

class GenotypeTests: XCTestCase {
    
    func testNull() throws {
        let geno = Genotype()
        XCTAssertTrue(geno.isEmpty)
        XCTAssertFalse(geno.isHeterozygote)
        XCTAssertEqual(String("\(geno)"), "-")
        XCTAssertEqual(geno.ploidy, .Missing)
        XCTAssertEqual(geno, Genotype())
        XCTAssertEqual(geno.asVector(alleles: ["A", "B", "C"]), [0.0, 0.0, 0.0])
        XCTAssertEqual( geno.left, geno.maskedLeft )
        XCTAssertEqual( geno.right, geno.maskedRight )

    }

    func testHaplid() throws {
        let geno = Genotype(raw: "A")
        XCTAssertFalse(geno.isEmpty)
        XCTAssertFalse(geno.isHeterozygote)
        XCTAssertEqual(String("\(geno)"), "A")
        XCTAssertEqual(geno.ploidy, .Haploid)
        XCTAssertEqual(geno, Genotype(raw: "A"))
        XCTAssertEqual(geno.asVector(alleles: ["A", "B", "C"]), [1.0, 0.0, 0.0])
        XCTAssertEqual( geno.left, geno.maskedLeft )
        XCTAssertEqual( geno.right, geno.maskedRight )

    }

    func testHeterozygote() throws {
        let geno = Genotype(raw: "A:B")
        XCTAssertFalse(geno.isEmpty)
        XCTAssertTrue(geno.isHeterozygote)
        XCTAssertEqual(String("\(geno)"), "A:B")
        XCTAssertEqual(geno.ploidy, .Diploid)
        XCTAssertEqual(geno, Genotype(raw: "A:B"))
        XCTAssertEqual(geno.asVector(alleles: ["A", "B", "C"]), [1.0, 1.0, 0.0])
        XCTAssertEqual( geno.left, geno.maskedLeft )
        XCTAssertEqual( geno.right, geno.maskedRight )

    }
    
    func testAlternativeInit() throws {
        let geno = Genotype(alleles: ("C","A"))
        XCTAssertFalse(geno.isEmpty)
        XCTAssertTrue(geno.isHeterozygote)
        XCTAssertEqual(String("\(geno)"), "A:C")
    }

    func testAlternativeInit2() throws {
        let geno = Genotype(alleles: ("A","B"))
        XCTAssertFalse(geno.isEmpty)
        XCTAssertTrue(geno.isHeterozygote)
        XCTAssertEqual(String("\(geno)"), "A:B")
    }

    
    func testHomozygote() throws {
        let geno = Genotype(raw: "A:A")
        XCTAssertFalse(geno.isEmpty)
        XCTAssertFalse(geno.isHeterozygote)
        XCTAssertEqual(String("\(geno)"), "A:A")
        XCTAssertEqual(geno.ploidy, .Diploid)
        XCTAssertEqual(geno, Genotype(raw: "A:A"))
        XCTAssertEqual(geno.asVector(alleles: ["A", "B", "C"]), [2.0, 0.0, 0.0])
        XCTAssertEqual( geno.left, geno.maskedLeft )
        XCTAssertEqual( geno.right, geno.maskedRight )

    }

    
    func testMaskedAllelesUndefined() throws {
        let geno = Genotype.DefaultHeterozygoteUndefined()
        XCTAssertFalse(geno.isEmpty)
        XCTAssertTrue(geno.isHeterozygote)
        XCTAssertEqual(String("\(geno)"), "A:B")
        XCTAssertEqual(geno.ploidy, .Diploid)
        XCTAssertEqual(geno, Genotype(raw: "A:B"))
        XCTAssertEqual(geno.asVector(alleles: ["A", "B", "C"]), [1.0, 1.0, 0.0])
        XCTAssertEqual( geno.left, geno.maskedLeft )
        XCTAssertEqual( geno.masking, .Undefined)
        XCTAssertEqual( geno.right, geno.maskedRight )
    }
    
    
    func testMaskedAllelesMotherRight() throws {
        let geno = Genotype.DefaultHeterozygoteMomRight()
        XCTAssertFalse(geno.isEmpty)
        XCTAssertTrue(geno.isHeterozygote)
        XCTAssertEqual(String("\(geno)"), "A")
        XCTAssertEqual(geno.ploidy, .Diploid)
        XCTAssertEqual(geno, Genotype(raw: "A:B"))
        XCTAssertEqual(geno.asVector(alleles: ["A", "B", "C"]), [1.0, 1.0, 0.0])
        XCTAssertEqual( geno.left, geno.maskedLeft )
        XCTAssertEqual( geno.masking, .ParentRight)
        XCTAssertEqual( geno.right, "B" )
        XCTAssertEqual( geno.maskedLeft, "A")
        XCTAssertEqual( geno.maskedRight, "")
    }
    
    func testMaskedAllelesMotherLeft() throws {
        let geno = Genotype.DefaultHeterozygoteMomLeft()
        XCTAssertFalse(geno.isEmpty)
        XCTAssertTrue(geno.isHeterozygote)
        XCTAssertEqual(String("\(geno)"), "B")
        XCTAssertEqual(geno.ploidy, .Diploid)
        XCTAssertEqual(geno, Genotype(raw: "A:B"))
        XCTAssertEqual(geno.asVector(alleles: ["A", "B", "C"]), [1.0, 1.0, 0.0])
        XCTAssertEqual( geno.left, "A" )
        XCTAssertEqual( geno.masking, .ParentLeft)
        XCTAssertEqual( geno.maskedLeft, "")
        XCTAssertEqual( geno.maskedRight, "B")
    }
    
    
    func testAMOVADistances() throws {
        let AA = Genotype(raw: "A:A")
        let AB = Genotype(raw: "A:B")
        let BB = Genotype(raw: "B:B")
        let BC = Genotype(raw: "B:C")
        let CD = Genotype(raw: "C:D")

        XCTAssertEqual(amovaDistance(geno1: AA, geno2: AA), 0.0)
        XCTAssertEqual(amovaDistance(geno1: AA, geno2: AB), 1.0)
        XCTAssertEqual(amovaDistance(geno1: AB, geno2: AA), 1.0)
        XCTAssertEqual(amovaDistance(geno1: AA, geno2: BB), 4.0)
        XCTAssertEqual(amovaDistance(geno1: AB, geno2: BC), 1.0)
        XCTAssertEqual(amovaDistance(geno1: AA, geno2: BC), 3.0)
        XCTAssertEqual(amovaDistance(geno1: AB, geno2: CD), 2.0)
    }
    
    
    func testAddition() throws {
        
        let mom = Genotype(raw: "A:A")
        let dad = Genotype(raw: "B:B")
        
        let off = mom + dad
        
        XCTAssertFalse( off.isEmpty )
        XCTAssertTrue( off.isHeterozygote )
        XCTAssertEqual( off, Genotype(raw: "A:B"))
        
        let dad2 = Genotype()
        let off2 = mom + dad2
        XCTAssertTrue( off2.isEmpty )
        XCTAssertFalse( off2.isHeterozygote )
    }
    
    
    func testStaticDefaults() throws {
        
        let genoNull = Genotype.DefaultNULL()
        XCTAssertTrue( genoNull.isEmpty )
        
        let genoHap = Genotype.DefaultHaploid()
        XCTAssertEqual( genoHap.ploidy, .Haploid)
        
        let genoHom = Genotype.DefaultHomozygote()
        XCTAssertEqual( genoHom, Genotype(raw: "A:A"))
        XCTAssertEqual( genoHom.masking, .NoMasking)
        
        let genoHet = Genotype.DefaultHeterozygote()
        XCTAssertEqual( genoHet, Genotype(raw: "A:B"))
        
        let genoMomLeft = Genotype.DefaultHeterozygoteMomLeft()
        XCTAssertEqual( genoMomLeft, Genotype.DefaultHeterozygote())
        XCTAssertEqual( genoMomLeft.masking, .ParentLeft)
        
        let genoMomRight = Genotype.DefaultHeterozygoteMomRight()
        XCTAssertEqual( genoMomRight, Genotype.DefaultHeterozygote())
        XCTAssertEqual( genoMomRight.masking, .ParentRight)
        
        let genoMomUndef = Genotype.DefaultHeterozygoteUndefined()
        XCTAssertEqual( genoMomUndef, Genotype.DefaultHeterozygote())
        XCTAssertEqual( genoMomUndef.masking, .Undefined )
        
    }
    
    
    
}
