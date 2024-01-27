//
//  GroupedTableView.swift
//
//
//  Created by Rodney Dyer on 1/26/24.
//

import SwiftUI

struct GroupedTableView: View {
    var title: String
    var data: [KeyValueData]
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.title2)
                Spacer()
                Button(action: {
                    exportDataToR()
                }, label: {
                    Image(systemName: "r.circle")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.primary, Color.accentColor)
                })
            }
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
            .cornerRadius(5.0)
        }
        .padding()
    }
    
    
    private func exportDataToR() {
        
        let resp = data.asRData(named: "data")
        #if os(iOS)
        UIPasteboard.general.string = resp
        #elseif os(macOS)
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(resp, forType: .string)
        #endif
    }

}

#Preview {
    GroupedTableView( title: "Diversity Measures Across Regions for WNT",
                      data: Population.DefaultPopulation.diversityFor( level: "Region",
                                                                  at: "WNT").toKeyValueData(grouped: false ))
}
