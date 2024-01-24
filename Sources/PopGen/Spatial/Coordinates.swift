//
//  File.swift
//  
//
//  Created by Rodney Dyer on 1/24/24.
//

import Foundation
import SwiftData

/// Spatial storage container for spatial data
///
/// This is the storage container for geospatial coordinates.
@Model public class Coordinates {
    
    /// UUID Identifier
    public let id: UUID
    
    /// Longitude estimate
    public var longitude: [Double]
    
    /// Latitude estimate
    public var latitude: [Double]
    
    /// Initializer
    init() {
        self.id = UUID()
        self.longitude = []
        self.latitude = []
    }
    
}
