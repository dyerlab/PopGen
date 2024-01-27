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
//  WierCockerhamTests.swift
//
//
//  Created by Rodney Dyer on 7/20/22.
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

final class WierCockerhamTests: XCTestCase {


    func testWC() throws {
        
        let allData = Population.DefaultPopulation
        
        if let son101 = allData.subpopulation(at: "Population", named: "101")?.individuals,
           let son102 = allData.subpopulation(at: "Population", named: "32")?.individuals,
           let son32 = allData.subpopulation(at: "Population", named: "32")?.individuals {
            
            var genotypes1 = son101.getGenotypes(named: "EN")
            genotypes1.append( contentsOf: son32.getGenotypes(named: "EN"))
            genotypes1.append( contentsOf: son102.getGenotypes(named: "EN"))

            
            print("Genotypes in WCTests")
            print("\(genotypes1.count) genotypes")
            print("\(genotypes1)")
            
            var locales = Array(repeating: "101", count: son101.count )
            locales.append(contentsOf: Array( repeating: "32", count: son32.count))
            locales.append(contentsOf:  Array( repeating: "102", count: son102.count))
            
            
            let wc = WierCockerham(locus: "LTRS", genotypes: genotypes1, partitions: locales )
            
            let Dsum = wc.D.sum
            print("DSum: \(Dsum)")
            
            print("\(wc)")
            
            // print("\(wc.C)")
        }
        

    }


}
