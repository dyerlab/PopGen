//
//  File.swift
//  
//
//  Created by Rodney Dyer on 1/24/24.
//

import Foundation


/// Spatial storage container for spatial data
///
/// This is the storage container for geospatial coordinates.
public class Coordinates {
    
    /// UUID Identifier
    public let id: UUID
    
    /// Longitude estimate
    public var longitude: [Double]
    
    /// Latitude estimate
    public var latitude: [Double]
    
    /// How many in the entry
    public var count: Int {
        return latitude.count
    }
    
    /// Initializer
    init() {
        self.id = UUID()
        self.longitude = []
        self.latitude = []
    }
    
    /// adding coordiantews
    public func append( longitude: Double, latitude: Double) {
        self.longitude.append( longitude )
        self.latitude.append( latitude )
    }
    
}
