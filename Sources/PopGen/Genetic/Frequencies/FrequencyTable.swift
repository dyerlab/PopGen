//
//  SwiftUIView.swift
//  
//
//  Created by Rodney Dyer on 1/22/24.
//

import SwiftUI

struct FrequencyTable: View {
    var frequencies: Frequencies
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Allele Frequencies: \(frequencies.locus)")
                .font(.title2)
            KeyValueTable(data: frequencies.asKeyValueData )
        }
        .padding()

    }
}

#Preview {
    FrequencyTable(frequencies: Frequencies.Default() )
}
