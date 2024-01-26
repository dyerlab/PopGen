//
//  File.swift
//
//
//  Created by Rodney Dyer on 1/25/24.
//

import Foundation


/// The nested storage structure for individuals
public class Population {
    
    /// The name of the stratum
    public var name: String = ""
    
    /// The nesting level of the stratum
    public var level: String = ""
    
    
    /// Private individuals
    private var _individuals: [Individual] = []
    
    
    /// The set of individuals in this level
    ///
    /// If this is the basal level, then it is full of the actual individuals. However,
    ///   if not, it will pull all the indiviudals from subdivisions.
    public var individuals: [Individual] {
        
        get {
            if subpopulations.isEmpty {
                return self._individuals
            } else {
                var ret = [Individual]()
                for pop in self.subpopulations {
                    ret.append( contentsOf: pop.individuals )
                }
                return ret
            }
        }
        set {
            self._individuals = newValue
        }
    }
    
    /// Frequencies
    


    
    /// Subpopualtions
    public var subpopulations: [Population] = []
    
    
    
    /// count of individuals
    public var count: Int {
        return individuals.count
    }
    
    /// Init for subgroups
    init(level: String, name: String ) {
        self.level = level
        self.name = name
    }
    
    /// Init with partitions and individuals
    ///
    /// This one is the init for the basal level object and it
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
    
    /// The nested structure creator
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
    
    
    /// Getting a specific locus
    public func locusNamed( name: String) -> [Genotype] {
        return self.individuals.compactMap { $0.loci[name] }
    }
    
    /// Getting frequencies for a specific locus
    public func frequencyForLocus( named: String ) -> Frequencies {
        return Frequencies(locus: named, genotypes: self.locusNamed(name: named) )
    }
 
    
    /// All subpopulations at a level
    public func subpopulations(at level: String) -> [Population] {
        var ret = [Population]()
        
        for subpopulation in subpopulations {
            if subpopulation.level == level {
                ret.append( subpopulation )
            }
            else {
                ret.append(contentsOf: subpopulation.subpopulations(at: level))
            }
        }
        
        return ret
    }
    
    
    /// Specific subpopulation at a level
    public func subpopulation( at level: String, named name: String) -> Population? {
        let ret = self.subpopulations(at: level).first(where: { $0.name == name })
        return ret
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


