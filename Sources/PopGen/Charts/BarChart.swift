//
//  BarChart.swift
//  
//
//  Created by Rodney Dyer on 1/26/24.
//

import SwiftUI
import Charts

struct BarChart: View {
    var title: String
    var xlab: String
    var ylab: String
    var data: [KeyValueData]
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.title2)
                Spacer()
                Button(action: {
                    self.exportDataToR()
                }, label: {
                    Image(systemName: "r.circle")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.primary, Color.accentColor)
                })
            }
            Chart( data ) { item in
                BarMark(
                    x: .value("label", item.label),
                    y: .value("value", item.value)
                )
                .cornerRadius( 8 )
                
            }
            .chartXAxisLabel(position: .bottom,
                             alignment: .center,
                             content: {
                Text(xlab)
            })
            .chartYAxisLabel(position: .trailing,
                             alignment: .center,
                             content: {
                Text(ylab)
            })
        }
        .padding()
        
    }
    
    private func exportDataToR() {
        
        let resp = data.asRData(named: "data.\(ylab)")
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
    List {
        BarChart( title: "WNT Allele Frequencies",
                  xlab: "Allele",
                  ylab: "Frequency",
                  data: Population.DefaultPopulation.frequencyForLocus(named: "WNT").asKeyValueData )
        Spacer()
        BarChart( title: "WNT Allelic Diversity",
                  xlab: "Population",
                  ylab: "Ae",
                  data: Population.DefaultPopulation.diversityFor( level: "Region",
                                                                   at: "WNT").toKeyValueData(grouped: true).filter { $0.grouping == "Ae" } )
        

    }
}
