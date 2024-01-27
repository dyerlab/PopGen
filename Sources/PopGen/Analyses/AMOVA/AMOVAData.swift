//
//  File.swift
//  
//
//  Created by Rodney Dyer on 1/26/24.
//

import Foundation

/// Row data structure for AMOVA
public struct AMOVAData: Identifiable {
    public let id: UUID
    public var source: String
    public var df: Int
    public var SS: Double
    public var MS: Double?
    
    init(source: String, df: Int, SS: Double, MS: Double? = nil ) {
        self.id = UUID()
        self.source = source
        self.df = df
        self.SS = SS
        self.MS = MS
    }
    
}




