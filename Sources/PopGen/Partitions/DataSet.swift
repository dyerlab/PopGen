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
    
    public static func DefaultBaja() -> [Individual] {
        let data = DataSet().bajaData()
        var ret = [Individual]()
        
            for row in data {
                let ind = Individual()
                ind.strata[ "Region" ] = row[0]
                ind.strata[ "Population" ] = row[1]
                if let lat = Double(row[2]),
                   let lon = Double(row[3]) {
                    ind.latitude = lat + Double.random(in: 0...100) / 10000.0
                    ind.longitude = lon + Double.random(in: 0...100) / 10000.0
                }
                ind.loci["LTRS"] = Genotype(raw: row[4])
                ind.loci["WNT"] = Genotype(raw: row[5])
                ind.loci["EN"] = Genotype(raw: row[6])
                ind.loci["EF"] = Genotype(raw: row[7])
                ind.loci["ZMP"] = Genotype(raw: row[8])
                ind.loci["AML"] = Genotype(raw: row[9])
                ind.loci["ATPS"] = Genotype(raw: row[10])
                ind.loci["MP20"] = Genotype(raw: row[11])
                ret.append( ind )
            }
        return ret
    }
    
    public static func Default() -> DataSet {
        let store = DataSet()
        for ind in DefaultBaja() {
            store.addIndividual(ind: ind )
        }
        return store
    }

    private func bajaData() -> [[String]] {
        var ret = RawData.mainClade
        ret.append(contentsOf: RawData.sonoranDesert )
        return ret
    }

}


