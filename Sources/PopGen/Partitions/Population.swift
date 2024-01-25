//
//  File.swift
//  
//
//  Created by Rodney Dyer on 1/25/24.
//

import Foundation


/// The nested storage structure for individuals
public class Population {
    
    /// The name of the
    public var name: String = ""
    public var level: String = ""
    public var individuals: [Individual] = []
    public var subpopulations: [Population] = []
    
    
    
    /// count of individuals
    public var count: Int {
        if individuals.isEmpty {
            return subpopulations.compactMap {$0.count}.reduce( 0, + )
        } else {
            return individuals.count
        }
    }
    
    
    
    /// Init for top-level group
    init(partitions: [Partition], coordinates: Coordinates, loci: [Locus]) {
        self.name = "All Samples"
        self.level = ""
        
        
        for i in 0 ..< coordinates.count {
            let ind = Individual()
            ind.latitude = coordinates.latitude[i]
            ind.longitude = coordinates.longitude[i]
            for loc in loci {
                ind.loci[ loc.name ] = loc.genotypes[i]
            }
            
            var partitionLevels = [String]()
            var partitionNames = [String]()
            for partition in partitions {
                partitionLevels.append( partition.level )
                partitionNames.append( partition.names[i])
            }
            
            addIndividual(individual: ind, levels: partitionLevels, names: partitionNames)
        }
        
    }
    
    /// Init for subgroups
    init(level: String, name: String ) {
        self.level = level
        self.name = name
    }
    
    
    /// Add individual with names and levels, make subgroups as necessary
    func addIndividual(individual: Individual, levels: [String] = [], names: [String] = [] ) {
        
        // I am the target because no levels OR matching levels
        if levels.isEmpty  {
            self.individuals.append( individual )
        }
        
        // Existing Subpopulation is the target
        else if let subpop = subpopulations.first(where: {$0.name == names[0] }) {
            subpop.addIndividual(individual: individual )
        }
        
        // Do not have subpop, make it and pass along all the data remaining data
        else {
            let remainingLevels = levels.count == 1 ? [] : Array<String>( levels.dropFirst() )
            let remainingNames = names.count == 1 ? [] : Array<String>( names.dropFirst() )
            let subpop = Population(level: levels[0], name: names[0])
            subpop.addIndividual(individual: individual, levels: remainingLevels, names: remainingNames)
            self.subpopulations.append( subpop )
        }
        
    }
    
}

extension Population: CustomStringConvertible {
    
    public var description: String {
        
        var ret = String("\(self.level): \(self.name) \(self.count) \n" )
        for subpopulation in self.subpopulations {
            ret += String(" \(subpopulation.description)")
        }
        return ret
        
    }
}


