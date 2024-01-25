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
    
    /// Init for subgroups
    init(level: String, name: String ) {
        self.level = level
        self.name = name
    }
    
    
    init( individuals: [Individual], partitions: [Partition]  ) {
        self.level = "All"
        self.name = "All"
        
        
        let levels = partitions.map { $0.level }
        
        
        // Cycle through all individuals
        for i in 0 ..< individuals.count {
            
            // Find all strata keys
            let names = partitions.map { $0.names[i] }
            
            
            storeOrPassAlong(individual: individuals[i],
                             names: names,
                             levels: levels)
            
        }
        
        
    }
    
    
    func storeOrPassAlong( individual: Individual, names: [String], levels: [String] ) {
        
        // Store
        if names.isEmpty || levels.isEmpty {
            self.individuals.append( individual )
        }
        else {
            
            // Get subpop
            let leftoverNames = Array<String>(names.dropFirst())
            let leftoverLevels = Array<String>(levels.dropFirst())
            
            // subpopulation already exists
            if let subpop = self.subpopulations.first(where: {$0.name == names[0] && $0.level == levels[0] } ) {
                
                subpop.storeOrPassAlong( individual: individual,
                                         names: leftoverNames,
                                         levels: leftoverLevels )
                
            }
            
            // no subpopulation by that name here, make new
            else {
                let subpop = Population.init(level: levels[0], name: names[0])
                subpop.storeOrPassAlong( individual: individual,
                                         names: leftoverNames,
                                         levels: leftoverLevels )
                self.subpopulations.append( subpop )
            }
        }
        
    }
    
    
}

extension Population: CustomStringConvertible {
    
    public var description: String {
        
        var ret = String("\(self.level): \(self.name) \(self.count) individuals, \(subpopulations.count) subpopulations\n" )
        for subpopulation in self.subpopulations {
            ret += String(" \(subpopulation.description)")
        }
        return ret
        
    }
}


