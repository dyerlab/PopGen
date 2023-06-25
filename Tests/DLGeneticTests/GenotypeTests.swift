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
        let geno = Locus()
        XCTAssertTrue(geno.isEmpty)
        XCTAssertFalse(geno.isHeterozygote)
        XCTAssertEqual(String("\(geno)"), "-")
        XCTAssertEqual(geno.ploidy, .Missing)
        XCTAssertEqual(geno, Locus())
        XCTAssertEqual(geno.asVector(alleles: ["A", "B", "C"]), [0.0, 0.0, 0.0])
        XCTAssertEqual( geno.left, geno.maskedLeft )
        XCTAssertEqual( geno.right, geno.maskedRight )

    }

    func testHaplid() throws {
        let geno = Locus(raw: "A")
        XCTAssertFalse(geno.isEmpty)
        XCTAssertFalse(geno.isHeterozygote)
        XCTAssertEqual(String("\(geno)"), "A")
        XCTAssertEqual(geno.ploidy, .Haploid)
        XCTAssertEqual(geno, Locus(raw: "A"))
        XCTAssertEqual(geno.asVector(alleles: ["A", "B", "C"]), [1.0, 0.0, 0.0])
        XCTAssertEqual( geno.left, geno.maskedLeft )
        XCTAssertEqual( geno.right, geno.maskedRight )

    }

    func testHeterozygote() throws {
        let geno = Locus(raw: "A:B")
        XCTAssertFalse(geno.isEmpty)
        XCTAssertTrue(geno.isHeterozygote)
        XCTAssertEqual(String("\(geno)"), "A:B")
        XCTAssertEqual(geno.ploidy, .Diploid)
        XCTAssertEqual(geno, Locus(raw: "A:B"))
        XCTAssertEqual(geno.asVector(alleles: ["A", "B", "C"]), [1.0, 1.0, 0.0])
        XCTAssertEqual( geno.left, geno.maskedLeft )
        XCTAssertEqual( geno.right, geno.maskedRight )

    }
    
    func testAlternativeInit() throws {
        let geno = Locus(alleles: ("C","A"))
        XCTAssertFalse(geno.isEmpty)
        XCTAssertTrue(geno.isHeterozygote)
        XCTAssertEqual(String("\(geno)"), "A:C")
    }

    func testAlternativeInit2() throws {
        let geno = Locus(alleles: ("A","B"))
        XCTAssertFalse(geno.isEmpty)
        XCTAssertTrue(geno.isHeterozygote)
        XCTAssertEqual(String("\(geno)"), "A:B")
    }

    
    func testHomozygote() throws {
        let geno = Locus(raw: "A:A")
        XCTAssertFalse(geno.isEmpty)
        XCTAssertFalse(geno.isHeterozygote)
        XCTAssertEqual(String("\(geno)"), "A:A")
        XCTAssertEqual(geno.ploidy, .Diploid)
        XCTAssertEqual(geno, Locus(raw: "A:A"))
        XCTAssertEqual(geno.asVector(alleles: ["A", "B", "C"]), [2.0, 0.0, 0.0])
        XCTAssertEqual( geno.left, geno.maskedLeft )
        XCTAssertEqual( geno.right, geno.maskedRight )

    }

    
    func testMaskedAllelesUndefined() throws {
        let geno = Locus.DefaultHeterozygoteUndefined()
        XCTAssertFalse(geno.isEmpty)
        XCTAssertTrue(geno.isHeterozygote)
        XCTAssertEqual(String("\(geno)"), "A:B")
        XCTAssertEqual(geno.ploidy, .Diploid)
        XCTAssertEqual(geno, Locus(raw: "A:B"))
        XCTAssertEqual(geno.asVector(alleles: ["A", "B", "C"]), [1.0, 1.0, 0.0])
        XCTAssertEqual( geno.left, geno.maskedLeft )
        XCTAssertEqual( geno.masking, .Undefined)
        XCTAssertEqual( geno.right, geno.maskedRight )
    }
    
    
    func testMaskedAllelesMotherRight() throws {
        let geno = Locus.DefaultHeterozygoteMomRight()
        XCTAssertFalse(geno.isEmpty)
        XCTAssertTrue(geno.isHeterozygote)
        XCTAssertEqual(String("\(geno)"), "A")
        XCTAssertEqual(geno.ploidy, .Diploid)
        XCTAssertEqual(geno, Locus(raw: "A:B"))
        XCTAssertEqual(geno.asVector(alleles: ["A", "B", "C"]), [1.0, 1.0, 0.0])
        XCTAssertEqual( geno.left, geno.maskedLeft )
        XCTAssertEqual( geno.masking, .MotherRight)
        XCTAssertEqual( geno.right, "B" )
        XCTAssertEqual( geno.maskedLeft, "A")
        XCTAssertEqual( geno.maskedRight, "")
    }
    
    func testMaskedAllelesMotherLeft() throws {
        let geno = Locus.DefaultHeterozygoteMomLeft()
        XCTAssertFalse(geno.isEmpty)
        XCTAssertTrue(geno.isHeterozygote)
        XCTAssertEqual(String("\(geno)"), "B")
        XCTAssertEqual(geno.ploidy, .Diploid)
        XCTAssertEqual(geno, Locus(raw: "A:B"))
        XCTAssertEqual(geno.asVector(alleles: ["A", "B", "C"]), [1.0, 1.0, 0.0])
        XCTAssertEqual( geno.left, "A" )
        XCTAssertEqual( geno.masking, .MotherLeft)
        XCTAssertEqual( geno.maskedLeft, "")
        XCTAssertEqual( geno.maskedRight, "B")
    }
    
    
    func testAMOVADistances() throws {
        let AA = Locus(raw: "A:A")
        let AB = Locus(raw: "A:B")
        let BB = Locus(raw: "B:B")
        let BC = Locus(raw: "B:C")
        let CD = Locus(raw: "C:D")

        XCTAssertEqual(amovaDistance(geno1: AA, geno2: AA), 0.0)
        XCTAssertEqual(amovaDistance(geno1: AA, geno2: AB), 1.0)
        XCTAssertEqual(amovaDistance(geno1: AB, geno2: AA), 1.0)
        XCTAssertEqual(amovaDistance(geno1: AA, geno2: BB), 4.0)
        XCTAssertEqual(amovaDistance(geno1: AB, geno2: BC), 1.0)
        XCTAssertEqual(amovaDistance(geno1: AA, geno2: BC), 3.0)
        XCTAssertEqual(amovaDistance(geno1: AB, geno2: CD), 2.0)
    }
    
    
    func testAddition() throws {
        
        let mom = Locus(raw: "A:A")
        let dad = Locus(raw: "B:B")
        
        let off = mom + dad
        
        XCTAssertFalse( off.isEmpty )
        XCTAssertTrue( off.isHeterozygote )
        XCTAssertEqual( off, Locus(raw: "A:B"))
        
        let dad2 = Locus()
        let off2 = mom + dad2
        XCTAssertTrue( off2.isEmpty )
        XCTAssertFalse( off2.isHeterozygote )
    }
    
    
    func testStaticDefaults() throws {
        
        let genoNull = Locus.DefaultNULL()
        XCTAssertTrue( genoNull.isEmpty )
        
        let genoHap = Locus.DefaultHaploid()
        XCTAssertEqual( genoHap.ploidy, .Haploid)
        
        let genoHom = Locus.DefaultHomozygote()
        XCTAssertEqual( genoHom, Locus(raw: "A:A"))
        XCTAssertEqual( genoHom.masking, .NoMasking)
        
        let genoHet = Locus.DefaultHeterozygote()
        XCTAssertEqual( genoHet, Locus(raw: "A:B"))
        
        let genoMomLeft = Locus.DefaultHeterozygoteMomLeft()
        XCTAssertEqual( genoMomLeft, Locus.DefaultHeterozygote())
        XCTAssertEqual( genoMomLeft.masking, .MotherLeft)
        
        let genoMomRight = Locus.DefaultHeterozygoteMomRight()
        XCTAssertEqual( genoMomRight, Locus.DefaultHeterozygote())
        XCTAssertEqual( genoMomRight.masking, .MotherRight)
        
        let genoMomUndef = Locus.DefaultHeterozygoteUndefined()
        XCTAssertEqual( genoMomUndef, Locus.DefaultHeterozygote())
        XCTAssertEqual( genoMomUndef.masking, .Undefined )
        
    }
    
    
    
}
