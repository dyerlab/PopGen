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
//  Individual.swift
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


import Foundation
import CoreLocation


public class Individual: Codable, Identifiable {
    public var id: UUID
    public var coord: Coordinate?
    public var loci: [String: Genotype]
    public var stratum: String
    public var offspring: String
    
    public var isSpatial: Bool {
        return coord != nil
    }
    
    public var location: Location? {
        if let coord = coord {
            return Location(name: stratum, coordinate: CLLocationCoordinate2D(coordinate: coord))
        } else {
            return nil
        }
    }
    
    
    /// Default initiatiator
    public init() {
        id = UUID()
        loci = [String: Genotype]()
        stratum = ""
        offspring = ""
    }

    enum CodingKeys: String, CodingKey {
        case id
        case coord
        case stratum
        case offspring
        case loci
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        coord = try values.decode(Coordinate.self, forKey: .coord)
        stratum = try values.decode(String.self, forKey: .stratum)
        offspring = try values.decode( String.self, forKey: .offspring)
        loci = try values.decode(Dictionary.self, forKey: .loci)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(coord, forKey: .coord)
        try container.encode(stratum, forKey: .stratum)
        try container.encode(offspring, forKey: .offspring)
        try container.encode(loci, forKey: .loci)
    }
}


extension Individual: Hashable {
    
    public static func == (lhs: Individual, rhs: Individual) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

extension Individual: CustomStringConvertible {
    /// Overload of description for plotting
    public var description: String {
        var ret = [String]()

        ret.append(stratum)
        if( !offspring.isEmpty ) {
            ret.append( offspring )
        }
        
        if let coord = coord {
            ret.append(String("\(coord)"))
        }

        for key in loci.keys.sorted(by: { $0.compare($1, options: .numeric) == .orderedAscending }) {
            ret.append(String("\(loci[key]!)"))
        }

        return ret.joined(separator: ", ")
    }
}

public extension Individual {
    
    static func Default() -> Individual {
        let ind = Individual()
        ind.coord = Coordinate(longitude: -77, latitude: 36)
        ind.stratum = "RVA"


        let loci = ["1:1", "1:1", "1:2",
                    "1:1", "1:1", "7:9"]
        let names = ["LTRS", "WNT", "EN",
                     "EF", "ZMP", "AML"]

        for i in 0 ..< 6 {
            ind.loci[names[i]] = Genotype(raw: loci[i])
        }

        return ind
    }
    
    
    static func DefaultMom() -> Individual {
        let ind = Individual()
        
        ind.stratum = "Big Bertha"
        ind.offspring = "0"
        ind.coord = Coordinate(longitude: -77, latitude: 36)
        let loci = ["1:1", "1:2", "1:2"]
        let names = ["LTRS", "WNT", "EN"]
        for i in 0 ..< 3 {
            ind.loci[names[i]] = Genotype(raw: loci[i])
        }
        
        return ind
    }
    
    static func DefaultOffspring() -> Individual {
        let ind = Individual()
        
        ind.stratum = "Big Bertha"
        ind.offspring = "1"
        ind.coord = Coordinate(longitude: -77, latitude: 36)
        
        var nm = Genotype(raw: "1:2")
        nm.masking = .NoMasking
        ind.loci["NM"] = nm
        
        var un = Genotype(raw: "1:2")
        un.masking = .NoMasking
        ind.loci["UN"] = un
        
        var ml = Genotype(raw: "1:2")
        ml.masking = .MotherLeft
        ind.loci["ML"]  = ml
        
        var mr = Genotype(raw: "1:2")
        mr.masking = .MotherRight
        ind.loci["MR"] = mr
        
        var md = Genotype(raw: "1:2")
        md.masking = .MissingData
        ind.loci["MD"] = md
        
        return ind
    }
    
    

    
    
}
