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
//  GeneticStudio
//  Array+CLLocationCoordinate2D.swift
//
//  Created by Rodney Dyer on 10/27/21.
//  Copyright (c) 2021 The Dyer Laboratory.  All Rights Reserved.
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


import CoreLocation
import Foundation
import MapKit

/**
 Extensions for arrays of coordinates
 */
extension Array where Element == CLLocationCoordinate2D {
    
    public var centroid: CLLocationCoordinate2D {
        
        if self.isEmpty {
            return CLLocationCoordinate2D(latitude: 37.547082, longitude: -77.451514)
        }
        
        var maxLatitude: Double = -200
        var maxLongitude: Double = -200
        var minLatitude = Double(MAXFLOAT)
        var minLongitude = Double(MAXFLOAT)

        for location in self {
            if location.latitude < minLatitude {
                minLatitude = location.latitude
            }

            if location.longitude < minLongitude {
                minLongitude = location.longitude
            }

            if location.latitude > maxLatitude {
                maxLatitude = location.latitude
            }

            if location.longitude > maxLongitude {
                maxLongitude = location.longitude
            }
        }

        return CLLocationCoordinate2DMake(CLLocationDegrees((maxLatitude + minLatitude) * 0.5),
                                          CLLocationDegrees((maxLongitude + minLongitude) * 0.5))
    }

    public var span: MKCoordinateSpan {
        
        if self.isEmpty {
            return MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100)
        }
        
        
        var maxLatitude: Double = -200
        var maxLongitude: Double = -200
        var minLatitude = Double(MAXFLOAT)
        var minLongitude = Double(MAXFLOAT)

        for location in self {
            if location.latitude < minLatitude {
                minLatitude = location.latitude
            }

            if location.longitude < minLongitude {
                minLongitude = location.longitude
            }

            if location.latitude > maxLatitude {
                maxLatitude = location.latitude
            }

            if location.longitude > maxLongitude {
                maxLongitude = location.longitude
            }
        }

        return MKCoordinateSpan(latitudeDelta: maxLatitude - minLatitude,
                                longitudeDelta: maxLongitude - minLongitude)
    }

    public var region: MKCoordinateRegion {
        return MKCoordinateRegion(center: centroid, span: span)
    }
}
