//
//  PieChart.swift
//
//
//  Created by Rodney Dyer on 1/22/24.
//

import SwiftUI
import Charts

/// Generalized pie chart
struct PieChart: View {
    var title: String
    var data: [KeyValueData]
        
    var body: some View {
        ZStack {
        Chart( data) { datum in
            
            SectorMark(angle: .value(
                Text(verbatim: datum.label),
                datum.value),
                       innerRadius: .ratio(0.6),
                       angularInset: 1.5
            )
            .cornerRadius( 3 )
            .foregroundStyle(by: .value(
                Text(verbatim: datum.label),
                datum.label
            ))
            .annotation(position: .overlay){
                if datum.value != 0.0 {
                    Text(verbatim: datum.label)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .chartLegend(.hidden)
            Text("\(title)")
                .font(.title2)
        }
        .padding()
    }
}

#Preview {
    
    PieChart( title: "The Locus",
              data: Frequencies.Default().asKeyValueData )
}
