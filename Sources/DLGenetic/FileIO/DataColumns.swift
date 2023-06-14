//
//  File.swift
//  
//
//  Created by Rodney Dyer on 10/29/22.
//

import Foundation

public struct DataColumns {
    private let header: [String]
    var strata: [Int]
    var idCol: Int? = nil
    var latitude: Int? = nil
    var longitude: Int? = nil
    var loci: [Int]
    
    var isSpatial: Bool {
        return latitude != nil && longitude != nil
    }
    
    var hasID: Bool {
        return idCol != nil
    }
    
    var isEmpty: Bool {
        return strata.isEmpty && loci.isEmpty
    }
    
    init( raw: [[String]] ) {
        assert( raw.count > 0 )
        self.header = raw.first!
        self.strata = [Int]()
        self.loci = [Int]()
        
        for col in Array( 0 ..< header.count ) {
            if header[col] == "Longitude" {
                longitude = col
            }
            else if header[col] == "Latitude" {
                latitude = col
            }
            else if header[col] == "ID" {
                idCol = col
            }
            else {
                for i in 1 ..< raw.count {
                    if Genotype.canBeGenotype(raw: raw[i][col]) {
                        loci.append( col )
                        break
                    }
                }
                if !loci.contains( col ) {
                    strata.append( col )
                }
            }
        }
    }
}
