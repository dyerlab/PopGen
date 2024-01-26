//
//  GroupedTableView.swift
//
//
//  Created by Rodney Dyer on 1/26/24.
//

import SwiftUI

struct GroupedTableView: View {
    var data: [KeyValueData]
    
    var body: some View {
        Table( data ) {
            TableColumn("Partition", value: \.grouping)
            TableColumn("Parameter", value: \.label)
            TableColumn("Value") { item in
                if item.asDouble {
                    Text(String(format: "%0.4f", item.value))
                } else {
                    Text(String(format: "%0.0f", item.value))
                }
            }
        }
    }
}

#Preview {
    GroupedTableView( data: Population.DefaultPopulation.diversityFor( level: "Region",
                                                                  at: "WNT").toKeyValueData(grouped: false ))
}
