//
//  FrequencyTable.swift
//
//
//  Created by Rodney Dyer on 1/22/24.
//

import SwiftUI

struct FrequencyTable: View {
    var frequencies: Frequencies
    
    var data: [KeyValueData] {
        return frequencies.asKeyValueData
    }
    
    var body: some View {
        KeyValueTable(title: String("Allele Frequencies: \(frequencies.locus)"),
                      data: data )
    }

}

#Preview {
    FrequencyTable(frequencies: Frequencies.Default() )
}
