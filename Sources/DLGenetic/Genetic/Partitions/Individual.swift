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
    public var latitude: CLLocationDegrees?
    public var longitude: CLLocationDegrees?
    
    public var loci: [String: Genotype]
    public var strata: [String: String]
    
    
    public var locusNames: [String] {
        return loci.keys.sorted { $0.localizedStandardCompare($1) == .orderedAscending }
    }
    public var strataNames: [String] {
        return strata.keys.sorted { $0.localizedStandardCompare($1) == .orderedAscending }
    }
    public var isSpatial: Bool {
        return longitude != nil && latitude != nil
    }
    
    public var location: Location? {
        if let coord = self.coordinate {
            return Location(name: id.uuidString,
                            coordinate: coord )
        } else {
            return nil
        }
    }
    
    public var coordinate: CLLocationCoordinate2D? {
        if let lat = latitude,
           let lon = longitude {
            return CLLocationCoordinate2D( latitude: lat, longitude: lon)
        } else {
            return nil
        }
    }
    
    
    /// Default initiatiator
    public init() {
        id = UUID()
        loci = [String: Genotype]()
        strata = [String:String]()
    }

    enum CodingKeys: String, CodingKey {
        case id
        case latitude
        case longitude
        case strata
        case loci
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        latitude = try values.decode( CLLocationDegrees.self, forKey: .latitude)
        longitude = try values.decode( CLLocationDegrees.self, forKey: .longitude)
        strata = try values.decode(Dictionary.self, forKey: .strata)
        loci = try values.decode(Dictionary.self, forKey: .loci)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(strata, forKey: .strata)
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

        for key in strata.keys.sorted(by: { $0.compare($1, options: .numeric) == .orderedAscending }) {
            ret.append(String("\(strata[key]!)"))
        }
    
        if let lat = latitude {
            ret.append(String("\(lat)"))
        }
        
        if let lon = longitude {
            ret.append(String("\(lon)"))
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
        ind.latitude = 36.0
        ind.longitude = -77.0
        ind.strata["Population"] = "RVA"

        let loci = ["1:1", "1:1", "1:2",
                    "1:1", "1:1", "7:9"]
        let names = ["LTRS", "WNT", "EN",
                     "EF", "ZMP", "AML"]

        for i in 0 ..< 6 {
            ind.loci[names[i]] = Genotype(raw: loci[i])
        }

        return ind
    }
    
    
}
