//
//  File.swift
//
//
//  Created by Rodney Dyer on 6/2/22.
//

import Foundation
import DLMatrix



/// Single locus Wier & Cockerham Analysis
///
/// This is a Matrix Algebra version of this analysis.  This only does a single level in the
///   analysis.
public struct WierCockerham {
    
    /// The locus being examined
    public let locus: String
    
    /// The AMOVA distance matrix
    public let D: Matrix
    
    /// The derived Covariance (R-Mode) matrix
    public var C: Matrix
    
    /// The idempotent hypothesis matrix
    public let H: Matrix
    
    /// Vectors of individual locals.
    let strata: [String]
    
    /// Total degrees of freedom
    let dfT: Double
    
    /// Among strata degrees of freedom
    var dfA: Double {
        let K = strata.unique().count
        return Double(K) - 1.0
    }
    
    /// Error degrees of freedom.
    var dfW: Double {
        return dfT - dfA
    }
    
    /// Total Sums of squares
    public let SST: Double
    
    /// Within level sums of squared deviations
    public let SSW: Double
    
    /// Among locales sums of squared deviations
    public var SSA: Double {
        return SST - SSW
    }
    
    /// Error mean squares
    public var MSW: Double {
        return SSW / dfW
    }
    
    /// Treatment mean squares
    public var MSA: Double {
        return SSA / dfA
    }
    
    /// Return as array of AMOVAData for tabular output
    public var asAMOVAData: [AMOVAData] {
        var ret = [AMOVAData]()
        ret.append( AMOVAData(source: "Population", df: Int(dfA), SS: SSA, MS: MSA) )
        ret.append( AMOVAData(source: "Error", df: Int(dfW), SS: SSW, MS: MSW) )
        ret.append( AMOVAData(source: "Total", df: Int(dfT), SS: SST))
        return ret
    }
    
    /// Main init for this analysis.
    ///
    /// This anlayiss takes a vector of genotypes and a vector of partitions and creates the raw materials for
    ///     the overall analyses.
    init(locus: String, genotypes: [Genotype], partitions: [String]) {
        self.locus = locus
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
        
        print("making D")
        print("D Sum = \(D.sum)")
        
        H = Matrix.IdempotentHatMatrix(strata: strata )
        C = D.asCovariance
        SST = (H .* C).trace
        
        let I = Matrix.Identity( N: H.cols )
        SSW = ((I - H) .* C).trace
        
    }
    
    
    /// AMOVA iniit for this
    init(loci: [String], genotypes: [ [Genotype] ], partitions: [String] ) {
        if loci.count > 10 {
            self.locus = String( "\(loci.count) loci")
        } else {
            self.locus = loci.joined(separator: ", ")
        }
        
        
        let N = genotypes[0].count
        strata = partitions
        dfT = Double(N) - 1.0
        
        D = Matrix( N, N )
        for geno in 0 ..< genotypes.count {
            for i in 0 ..< N {
                for j in (i+1) ..< N {
                    D[i,j] += amovaDistance(geno1: genotypes[geno][i], geno2: genotypes[geno][j])
                    D[j,i] += D[i,j]
                }
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
    
    /// Override of descritpion to conform to `CustomStringConvertible`
    public var description: String {
        var ret = "W&C\n"
        
        ret += String("dfT: \(dfT), dfA: \(dfA), dfW: \(dfW)\n")
        ret += String("SST: \(SST), SSA: \(SSA), SSW: \(SSW)\n")
        ret += String("MSA: \(MSA), MSW: \(MSW)\n")
        
        // ret += "D: \n\(D)\n"
        
        return ret
    }
    
    
}



extension WierCockerham {
    
    static var DefaultWC: WierCockerham {
        
        let pop = Population.DefaultPopulation
        
        let strata = pop.strataForLevel( level: "Region" )
        let genotypes = pop.locusNamed(name: "WNT")
        
        return WierCockerham(locus: "WNT", genotypes: genotypes, partitions: strata)
    }
    
    
    static var DefaultAMOVA: WierCockerham {
        let strata = RawData.DefaultBajaPartitions[0].names
        let genos = RawData.DefaultBajaLoci
        let loci: [String] = genos.map{ $0.name }
        var genotypes = [ [Genotype] ]()
        for geno in genos {
            genotypes.append( geno.genotypes )
        }
        
        return WierCockerham(loci: loci, genotypes: genotypes, partitions: strata)
    }
}
