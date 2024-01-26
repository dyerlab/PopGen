//
//  GroupedDiversityTable.swift
//
//
//  Created by Rodney Dyer on 1/26/24.
//

import SwiftUI

struct GroupedDiversityTable: View {
    var title: String
    var data: [KeyValueData]
    var groups: [String]
    @State private var selectedGroup: String
    @State private var sortOrder = [KeyPathComparator(\KeyValueData.value, order: .forward)]
    var selectedData: [KeyValueData] {
        return data.filter{ $0.grouping == selectedGroup }
    }
    
    init( title: String, population: Population, subdivision: String, locus: String) {
        self.title = title
        self.data = population.diversityFor(level: subdivision, at: locus).toKeyValueData(grouped: true)
        self.groups = data.map { $0.grouping }.sorted().unique()
        _selectedGroup = State(initialValue: self.groups[0])
    }
    
    init( title: String, allData: [KeyValueData]) {
        self.title = title
        self.data = allData
        self.groups = data.map { $0.grouping }.sorted().unique()
        _selectedGroup = State(initialValue: self.groups[0])
    }
    
    
    
    var body: some View {
        VStack{
            Text(title)
                .font(.title2)
            
            HStack {
                Picker(selection: $selectedGroup, content: {
                    ForEach( groups, id: \.self ) { item in
                        Text(item)
                    }
                }, label: {
                    Text("Parameter:")
                })
                Button(action: {
                    self.exportDataToR()
                }, label: {
                    Image(systemName: "r.circle")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.primary, Color.accentColor)
                })
            }
            
            Table( selectedData ) {
                TableColumn("Partition", value: \.label)
                TableColumn("Value") { item in
                    if item.asDouble {
                        Text(String(format: "%0.4f", item.value))
                    } else {
                        Text(String(format: "%0.0f", item.value))
                    }
                }
            }
            .frame( minHeight: 150 )
        }
        .padding()
    }
    
    
    private func exportDataToR() {
        
        let resp = self.selectedData.asRData(named: "diversity.\(selectedGroup)")
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
    VStack(spacing: 10 ) {
        GroupedDiversityTable(title: "Genetic Diversity for WNT Partitioned Across Regions",
                              allData: Population.DefaultPopulation.diversityFor( level: "Region",
                                                                                  at: "WNT").toKeyValueData( grouped: true ))
        
        
        GroupedDiversityTable(title: "Genetic Diversity for MP20 Partitioned Across Regions",
                              population: Population.DefaultPopulation,
                              subdivision: "Population",
                              locus: "MP20" )
    }
    .frame( minHeight: 600)
}
