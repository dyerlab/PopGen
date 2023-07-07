//
//  File.swift
//  
//
//  Created by Rodney Dyer on 10/29/22.
//

import Foundation

public struct CSVReader {
    let path: String
    let contents: [[String]]
    
    init(path: String ) {
        self.path = path
        do {
            let raw = try String(contentsOfFile: path)
            contents = raw.components(separatedBy: "\n").map { $0.components(separatedBy: ",") }
        }
        catch {
            contents = [[String]]()
        }
    }
    
    func asDataStore() -> DataStore? {
        let ret = DataStore()
        let dcol = DataColumns(raw: self.contents)
        if dcol.isEmpty  {
            return nil 
        }
        let header = self.contents.first!
        
        for idx in 1 ..< contents.count {
            let vals = contents[idx]
            if !vals.isEmpty {
                let ind = Individual()
                for col in dcol.strata {
                    let key = header[col]
                    ind.strata[key] = vals[col]
                }
                for col in dcol.loci {
                    ind.loci[ header[col] ] = Locus(raw: vals[col] )
                }
                if dcol.isSpatial,
                   let lat = Double(vals[dcol.latitude!]),
                   let lon = Double( vals[dcol.longitude!]) {
                    ind.latitude = lat
                    ind.longitude = lon
                }
                
                // Add the individual
                ret.addIndividual(ind: ind)
                
            }
        }
        
        return ret
    }
    
    
    
}
