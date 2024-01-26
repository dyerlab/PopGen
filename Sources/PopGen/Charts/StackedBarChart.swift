//
//  StackedBarChart.swift
//  
//
//  Created by Rodney Dyer on 1/26/24.
//

import SwiftUI
import Charts

struct StackedBarChart: View {
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
                .foregroundStyle(by: .value("Allele", item.grouping))
                .cornerRadius( 8 )
            }
            .chartYAxisLabel(position: .trailing,
                             alignment: .center,
                             content: {
                Text(ylab)
            })
            .chartXAxisLabel(position: .bottom,
                             alignment: .center,
                             content: {
                Text(xlab)
            })
            .chartLegend(position: .top )
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
    StackedBarChart( title: "WNT Allele Frequencies",
                     xlab: "Partition",
                     ylab: "Frequencies",
                     data: Population.DefaultPopulation.frequenciesFor( level: "Region",
                                                                        at: "WNT").toKeyValueData(grouped: true))
}
