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
        return first?.strata.keys.sorted(by: { $0.compare($1, options: .numeric) == .orderedAscending }) ?? [String]()
    }
    
    
    
    /**
     All keys for individual including loci and coordinates.
     - Returns: Array of keys.
     */
    var allKeys: [String] {
        var ret = [String]()
        
        ret.append(contentsOf: strataKeys)
        ret.append("Longitude")
        ret.append("Latitude")
        ret.append(contentsOf: locusKeys)
        return ret
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
    
    /**
     Get all the genotypes for a single locus
     */
    func getGenotypes(named: String) -> [Locus] {
        return compactMap { $0.loci[named, default: Locus()] }
    }
    
    func levelsForStratum( named: String ) -> [String] {
        return compactMap { $0.strata[named, default: ""] }.unique().sorted(by: { $0.compare($1, options: .numeric) == .orderedAscending })
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
    
    /**
     Get all the strata for a single location
     - Parameters:
     - named: The name of the stratum of interest.
     - Returns: An array of values with the stratumfo reach indiviudal.
     */
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
        print("\(stratumName)")
        print("\(stratumLevel)")
        let ret = filter { $0.strata[ stratumName ] == stratumLevel }
        print("\(ret.description)")
        return ret
    }
    
    
    func lociByStrataLevel( locus: String, stratumName: String) -> [String: [Locus] ] {
        var ret = [String: [Locus] ]()
        let levels = self.levelsForStratum(named: stratumName )
        for level in levels {
            let inds = individualsForStratumLevel(stratumName: stratumName, stratumLevel: level)
            let genos = inds.getGenotypes(named: locus )
            ret[ level ] = genos
        }
        return ret
    }
    
    func locusFrequenciesByStrataLevel( locus: String, stratumName: String) -> [String: LocusFrequencies ] {
        var ret = [String: LocusFrequencies ]()
        let loci = lociByStrataLevel(locus: locus, stratumName: stratumName )
        
        for locusName in loci.keys  {
            ret[ locusName ] = LocusFrequencies(genotypes: loci[ locusName, default: [Locus]() ] )
        }
        return ret
    }
    
    
    func locusDiversityByStrataLevel( locus: String, stratumName: String) -> [String: GeneticDiversity ] {
        var ret = [String: GeneticDiversity]()
        let freqs = locusFrequenciesByStrataLevel(locus: locus, stratumName: stratumName)
        for locusName in freqs.keys {
            ret[ locusName ] = freqs[locusName, default: LocusFrequencies()].asDiversity
        }
        return ret 
    }
    
}
