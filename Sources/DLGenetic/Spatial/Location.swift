//
//  File.swift
//  
//
//  Created by Rodney Dyer on 6/7/22.
//


import Foundation
import CoreLocation


public struct Location: Identifiable {
    public let id = UUID()
    public let name: String
    public let coordinate: CLLocationCoordinate2D    
}
