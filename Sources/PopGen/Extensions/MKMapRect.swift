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
//  MKMapRect.swift
//
//
//  Created by Rodney Dyer on 5/9/22.
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

import Foundation
import MapKit

public extension MKMapRect {
    /// New Init based upon coordinate region
    init(region: MKCoordinateRegion) {
        self.init()
        let a = MKMapPoint(CLLocationCoordinate2D(latitude: region.center.latitude + (region.span.latitudeDelta / 2),
                                                  longitude: region.center.longitude - (region.span.longitudeDelta / 2)))
        let b = MKMapPoint(CLLocationCoordinate2D(latitude: region.center.latitude - (region.span.latitudeDelta / 2),
                                                  longitude: region.center.longitude + (region.span.longitudeDelta / 2)))
        origin = MKMapPoint(x: min(a.x, b.x), y: min(a.y, b.y))
        size = MKMapSize(width: abs(a.x - b.x), height: abs(a.y - b.y))
    }
}
