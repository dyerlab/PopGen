//
//  dyerlab.org                                          @dyerlab
//                      _                 _       _
//                   __| |_   _  ___ _ __| | __ _| |__
//                  / _` | | | |/ _ \ '__| |/ _` | '_ \
//                 | (_| | |_| |  __/ |  | | (_| | |_) |
//                  \__,_|\__, |\___|_|  |_|\__,_|_.__/
//                        |_ _/
//
//         Making Population Genetic Software That Doesn't Suck
//
//  DataStore.swift
//
//
//  Created by Rodney Dyer on 5/13/22.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.

import Foundation
import DLMatrix

public class DataSet: Codable, Identifiable  {
    
    /// List of all individuals in the data set
    public var individuals = [Individual]()
    
    /// Pre-allocated locus frequency distributions for all individuals.
    ///
    /// These are automatically populated by adding each individual to the
    ///   dataset.
    public var frequencies = [Frequencies]()
    
    /// The number of individuals in the data set
    public var count: Int {
        return individuals.count
    }
    
    /// Quick hack to see if it has entities.
    public var isEmpty: Bool {
        return individuals.count == 0
    }
    
    public var strataKeys: [String] {
        return individuals.strataKeys
    }
    
    public var locusKeys: [String] {
        return individuals.locusKeys
    }
    
    public var locations: [Location] {
        return self.individuals.compactMap { $0.location }
    }
    
    public init() { }
    
    /// Initializer from storage components.  This will verify:
    ///  - The number of loci and partitions are the same.
    ///  - If coordinates are not empty, they must also be the same size.
    public init(partitions: [Partition], coordinates: [Coordinates], loci: [Locus] ) {
        let N = partitions.count
        
        /// Make some
        if N > 0 && loci.count > 0 {
            if partitions.count != loci.count {
                return
            }
            if coordinates.count > 0 && ( coordinates.count != N || coordinates.count != loci.count ) {
                return
            }
        } else {
            return
        }
        
        for i in 0 ..< N {
            
            let ind = Individual()
            for stratum in partitions {
                ind.strata[ stratum.name ] = stratum.levels[i]
            }
            
            
        }
        
        
        
        
    }
    
    public init( individuals: [Individual] ) {
        for ind in individuals {
            addIndividual(ind: ind)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case individuals
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        individuals = try values.decode( Array<Individual>.self, forKey: .individuals)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode( individuals, forKey: .individuals)
    }
    
    public func addIndividual( ind: Individual ) {
        
        for locus in ind.locusNames {
            if let geno = ind.loci[locus] {
                
                var idx: Int
                if let i = frequencies.firstIndex(where: {$0.locus == locus} ){
                    idx = i
                } else {
                    idx = frequencies.count
                    let freq = Frequencies()
                    freq.locus = locus
                    self.frequencies.append( freq )
                }
                
                frequencies[idx].addGenotype(geno: geno)
            }
            else {
                print("Skipping null geno")
            }
        }
        individuals.append( ind )
    }
}



public extension DataSet {
    
    func genotypesFor( locus: String ) -> [Genotype] {
        return individuals.getGenotypes(named: locus)
    }
    
    func alleleFrequenciesFor( locus: String ) -> Frequencies {
        return self.frequencies.first(where: {$0.locus == locus} ) ?? Frequencies()
    }
    
    func geneticDiversityFor( locus: String ) -> Diversity {
        return Diversity(frequencies: alleleFrequenciesFor(locus: locus) )
    }
    
    func diversityForAllLoci() -> [Diversity] {
        var ret = [Diversity]()
        for freq in frequencies {
            ret.append( Diversity(frequencies: freq))
        }
        return ret
    }
    
    func frequencyForStrataLevels( locus: String, strata: String) -> [Frequencies] {
        var ret = [Frequencies]()
        let pops = partition(strata: strata)
        for pop in pops.keys {
            let freq = pops[pop, default: DataSet()].alleleFrequenciesFor(locus: locus)
            freq.locus = pop
            ret.append( freq )
        }
        return ret
    }
    
    func diversityForStratLevels( locus: String, strata: String ) -> [Diversity] {
        var ret =  [Diversity]()
        let pops = partition(strata: strata)
        for pop in pops.keys {
            var div = pops[pop, default: DataSet()].geneticDiversityFor(locus: locus)
            div.label = pop
            ret.append( div )
        }
        return ret
    }
    
    func diversityForAllLevelsAt( strata: String ) -> [Diversity] {
        var ret =  [Diversity]()
        let pops = partition(strata: strata)
        for pop in pops.keys {
            for locus in self.locusKeys {
                var div = pops[pop, default: DataSet()].geneticDiversityFor(locus: locus)
                div.label = pop
                div.locus = locus
                ret.append( div )
            }
        }
        return ret
    }
    
    
}



public extension DataSet {
    
    func individualsAtLevel( stratum: String, level: String ) -> [Individual] {
        return individuals.individualsForStratumLevel(stratumName: stratum, stratumLevel: level)
    }
    
    func dataStoreForLevel( stratum: String, level: String ) -> DataSet {
        let inds = individualsAtLevel(stratum: stratum, level: level)
        return DataSet(individuals: inds )
    }
    
    func sampleSizesForLevel( stratum: String ) -> [String:Int] {
        let levels = individuals.strataLevels(within: stratum)
        var ret = [String:Int]()
        levels.forEach{ ret[$0] = individualsAtLevel(stratum: stratum, level: $0).count }
        return  ret
    }
    
    func partition( strata: String) -> [String:DataSet] {
        var ret = [String:DataSet]()
        let levels = individuals.strataLevels(within: strata)
        for level in levels {
            ret[level] = dataStoreForLevel(stratum: strata, level: level)
        }
        return ret
    }
    
    func strataLocations( strata: String ) -> [String: [Location] ] {
        var ret = [String: [Location] ]()
        let levels = individuals.strataLevels(within: strata)
        levels.forEach{ ret[$0] = locationsForPartition(stratum: strata, location: $0) }
        return ret
    }
    
    func locationsForPartition( stratum: String, location: String) -> [Location] {
        return individualsAtLevel(stratum: stratum, level: location).locations
    }
    
}



extension DataSet: CustomStringConvertible {
    public var description: String {
        var ret = "DataStore with:\n"
        ret += " - \(self.individuals.count) individuals\n"
        ret += " - \(self.frequencies.count) frequencies\n"
        return ret
    }
}




extension DataSet {
    
    
    
    public static func Default() -> DataSet {
        let store = DataSet()
        for ind in RawData.DefaultBaja {
            store.addIndividual(ind: ind )
        }
        return store
    }
    
    
    
}


