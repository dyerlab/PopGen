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
//  GeneticStudio
//  Array+Individual.swift
//
//  Created by Rodney Dyer on 10/27/21.
//  Copyright (c) 2021 Rodney J Dyer.  All Rights Reserved.
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

import CoreLocation
import Foundation
import MapKit

/**
 Extensions for arrays  of individuals
 */

public extension Array where Element == Individual {
    /**
     Names of the loci
     - Returns: An array of locus names.
     */
    var locusKeys: [String] {
        return first?.loci.keys.sorted(by: { $0.compare($1, options: .numeric) == .orderedAscending }) ?? [String]()
    }
    
    /**
     Strata Keys
     - Returns: An array of strata in alphabetical order
     */
    var strataKeys: [String] {
        
        let keys = first?.strata.keys.sorted(by: { $0.compare($1, options: .numeric) == .orderedAscending }) ?? [String]()
        
        return keys
    }
    
    

    /**
     Get indication if it is spatial
     */
    var isSpatial: Bool {
        return self.first?.isSpatial ?? false
    }
    
    /**
     Find out how many have spatial coordinates
     */
    var numberWithCoordinates: Int {
        return self.compactMap { $0.isSpatial == true }.count
    }
    
    
    var strataCounts: [String: Int] {
        var ret = [String:Int]()
        for stratum in strataKeys {
            ret[stratum] = strataLevels(partition: stratum).count 
        }
        return ret
    }
    
    
    
    /**
     Get all the genotypes for a single locus
     */
    func getGenotypes(named: String) -> [Locus] {
        return compactMap { $0.loci[named, default: Locus()] }
    }
    
    
    
    
    var locations: [Location] {
        var ret = [Location]()
        for ind in self {
            if ind.isSpatial,
               let lat = ind.latitude,
               let lon = ind.longitude  {
                ret.append( Location(name: ind.id.uuidString,
                                     coordinate: CLLocationCoordinate2DMake(lat, lon)) )
            }
        }
        return ret
    }
    

    func getStrata( named: String ) -> [String] {
        return compactMap { $0.strata[named, default: ""]}
    }
    
    /**
     Get the levels for a specfic stratum
     - Parameters:
     - stratum: The Name of the strtatum
     - Returns: The set of unique values in the stratum
     */
    func strataLevels( partition: String ) -> [String] {
        return Set<String>(getStrata(named: partition)).unique()
    }
    
    
    /**
     Gets subset of individuals who have specific hierarchical level
     - Parameters:
     - stratumName: Name of the hierarchical level to look.
     - stratumLevel: The specific level for the stratum of interest
     - Returns: An array of individuals (or empty array) with indiviudals
     */
    func individualsForStratumLevel( stratumName: String, stratumLevel: String) -> [Individual] {
        let ret = filter { $0.strata[ stratumName ] == stratumLevel }
        return ret
    }
    
    
    func locusForStrataLevels( locus: String, stratumName: String) -> [String: [Locus] ] {
        var ret = [String: [Locus] ]()
        let strata = self.strataLevels(partition: stratumName )
        for stratum in strata {
            let inds = individualsForStratumLevel(stratumName: stratumName, stratumLevel: stratum)
            let genos = inds.getGenotypes(named: locus )
            ret[ stratum ] = genos
        }
        return ret
    }
    
    func frequenciesForStrataLevels( locus: String, stratumName: String) -> [String: LocusFrequencies ] {
        var ret = [String: LocusFrequencies ]()
        let lociForStratum = locusForStrataLevels(locus: locus, stratumName: stratumName )
        for stratumName in lociForStratum.keys  {
            ret[ stratumName ] = LocusFrequencies(genotypes: lociForStratum[ stratumName, default: [Locus]() ] )
        }
        return ret
    }
    
    
    func diversityByStrataLevel( locus: String, stratumName: String) -> [GeneticDiversity ] {
        var ret = [GeneticDiversity]()
        let freqs = frequenciesForStrataLevels(locus: locus, stratumName: stratumName)
        for stratum in freqs.keys {
            var div = freqs[stratum, default: LocusFrequencies()].asDiversity
            div.label = stratum
            ret.append( div )
        }
        return ret 
    }
    
}
