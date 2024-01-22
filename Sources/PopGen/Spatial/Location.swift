//
//  File.swift
//  
//
//  Created by Rodney Dyer on 6/7/22.
//


import Foundation
import CoreLocation

/// Generic Location object for interacting with `MapKit`
public struct Location: Identifiable {
    
    /// Unique identifier
    public let id = UUID()
    
    /// The name of the site to be displayed on the map
    public let name: String
    
    /// Coordinate for the marker.
    public let coordinate: CLLocationCoordinate2D
    
    /// Default init for the location
    ///
    /// - Parameters:
    ///     - name: The name to be displayed on the map
    ///     - coordinate: The spatial location of the point.
    public init(name: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.coordinate = coordinate
    }
}
