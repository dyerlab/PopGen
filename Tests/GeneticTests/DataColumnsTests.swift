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
//  DataColumnsTests.swift
//
//
//  Created by Rodney Dyer on 10/29/22.
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

final class DataColumnsTests: XCTestCase {

    func testInit() throws {
        guard let path = Bundle.module.path(forResource: "arapat", ofType: "csv") else {
            print("Could not load path for resource 'arapat.csv'")
            return
        }
        print("Path to CSV: \(path)")
        XCTAssertFalse( path.isEmpty )
        let reader = CSVReader(path: path)
        
        XCTAssertEqual( reader.contents.count, 364)
        XCTAssertEqual( reader.contents[0].count, 14)
        let dcols = DataColumns(raw: reader.contents )
        
        XCTAssertTrue( dcols.isSpatial )
        XCTAssertTrue( dcols.hasID )
        XCTAssertEqual( dcols.longitude!, 5)
        XCTAssertEqual( dcols.latitude!, 4)
        XCTAssertEqual( dcols.strata, [0,1,2])
        XCTAssertEqual( dcols.loci, [6,7,8,9,10,11,12,13] )
    }


}
