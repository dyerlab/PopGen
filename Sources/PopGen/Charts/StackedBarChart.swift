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
            Text(title)
                .font(.largeTitle)
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
}

#Preview {
    StackedBarChart( title: "WNT Allele Frequencies",
                     xlab: "Partition",
                     ylab: "Frequencies",
                     data: Population.DefaultPopulation.frequenciesFor( level: "Region",
                                                                        at: "WNT").toKeyValueData(grouped: true))
}
