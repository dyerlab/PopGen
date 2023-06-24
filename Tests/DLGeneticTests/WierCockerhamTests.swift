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

@testable import DLGenetic
import XCTest

final class WierCockerhamTests: XCTestCase {

/*
    func testWC() throws {
        let store = DataStore.Default()
        let son101 = store.stratum(named: "101")
        let son102 = store.stratum(named: "102")
        
        
        var inds = son101.individuals
        inds.append(contentsOf: son102.individuals )
        
        for ind in inds {
            print("\(ind)")
        }
        
        
        var locales = Array(repeating: "101", count: son101.count )
        locales.append(contentsOf:  Array( repeating: "102", count: son102.count))
        
        
        let wc = WierCockerham(genotypes: inds.getGenotypes(named: "LTRS"), partitions: locales )
        
        print("\(wc)")
        
        print("\(wc.C)")

    }

 */
}
