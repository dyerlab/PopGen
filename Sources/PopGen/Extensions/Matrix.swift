//
//  File.swift
//  
//
//  Created by Rodney Dyer on 7/7/23.
//

import Foundation
import DLMatrix


public extension Matrix {
    
    static func forFrequencies( freqs: [Frequencies] ) -> Matrix {
        let numLables = freqs.count
        let theLabels = freqs.compactMap { $0.locus }.sorted(by: { $0.compare($1, options: .numeric) == .orderedAscending })
        var allAlleles = [String]()
        for freq in freqs {
            allAlleles.append(contentsOf: freq.alleles )
        }
        let alleles = Set<String>(allAlleles).unique().sorted(by: { $0.compare($1, options: .numeric) == .orderedAscending })
        let numAlleles = alleles.count
        
        let X = Matrix( numLables, numAlleles, theLabels, alleles )
        for row in 0 ..< numLables {
            let label = theLabels[row]
            if let freq = freqs.first(where: {$0.locus == label} ) {
                for col in 0 ..< alleles.count {
                    X[row,col] = freq.forAllele(allele: alleles[col] )
                }
            }
        }
        return X
    }
    
    
    static func forAllelicDiversity( divs: [Diversity] ) -> Matrix {
        let numLabels = divs.count
        let theLabels = divs.compactMap { $0.label }.sorted(by: { $0.compare($1, options: .numeric) == .orderedAscending })
        let X = Matrix( numLabels, 4, theLabels, ["N","A","A95","Ae"])
        X.digits = [0,0,0,4]
        for i in 0 ..< numLabels {
            let div = divs[i]
            X[i,0] = Double(div.N)
            X[i,1] = Double(div.A)
            X[i,2] = Double(div.A95)
            X[i,3] = div.Ae
        }
        return X
    }
    
    
    static func forGenotypicDiversity( divs: [Diversity] ) -> Matrix {
        let numLabels = divs.count
        let theLabels = divs.compactMap { $0.label }.sorted(by: { $0.compare($1, options: .numeric) == .orderedAscending })
        let X = Matrix( numLabels, 4, theLabels, ["N","Ho","He","F"])
        X.digits = [0,4,4,4]
        for i in 0 ..< numLabels {
            let div = divs[i]
            X[i,0] = Double(div.N)
            X[i,1] = div.Ho
            X[i,2] = div.He
            X[i,3] = div.F
        }
        
        return X
    }

        
}



