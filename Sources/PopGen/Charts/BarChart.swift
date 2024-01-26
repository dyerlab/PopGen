//
//  SwiftUIView.swift
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
            Text(title)
                .font(.title2)
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
                  data: Population.DefaultPopulation.frequencyForLocus(named: "LTRS").asKeyValueData )
        

    }
}
