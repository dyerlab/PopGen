//
//  File.swift
//  
//
//  Created by Rodney Dyer on 6/2/22.
//

import Foundation
import DLMatrix

public struct WierCockerham {
    
    public let D: Matrix
    public var C: Matrix
    public let H: Matrix
    let strata: [String]
    let dfT: Double
    var dfA: Double {
        let K = strata.unique().count
        return Double(K) - 1.0
    }
    var dfW: Double {
        return dfT - dfA
    }
    
    public let SST: Double
    public let SSW: Double
    public var SSA: Double {
        return SST - SSW
    }
    
    public var MSW: Double {
        return SSW / dfW
    }
    
    public var MSA: Double {
        return SSA / dfA
    }
    
    
    init(genotypes: [Locus], partitions: [String]) {
        let N = genotypes.count
        strata = partitions
        dfT = Double(N) - 1.0
        
        D = Matrix( N, N )
        for i in 0 ..< N {
            for j in (i+1) ..< N {
                D[i,j] = amovaDistance(geno1: genotypes[i], geno2: genotypes[j])
                D[j,i] = D[i,j]
            }
        }
        
        H = Matrix.IdempotentHatMatrix(strata: strata )
        C = D.asCovariance
        SST = (H .* C).trace
        
        let I = Matrix.Identity( N: H.cols )
        SSW = ((I - H) .* C).trace
        
    }
    
    

}



extension WierCockerham: CustomStringConvertible {
    
    public var description: String {
        var ret = "W&C\n"
        
        ret += String("dfT: \(dfT), dfA: \(dfA), dfW: \(dfW)\n")
        ret += String("SST: \(SST), SSA: \(SSA), SSW: \(SSW)\n")
        ret += String("MSA: \(MSA), MSW: \(MSW)\n")
        
        ret += "D: \n\(D)\n"
        
        return ret
    }
    
    
}
