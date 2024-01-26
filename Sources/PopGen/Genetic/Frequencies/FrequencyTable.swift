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
        VStack(alignment: .leading) {
            HStack {
                Text("Allele Frequencies: \(frequencies.locus)")
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
        
            KeyValueTable(data: data )
        }
        .padding()

    }
    
    private func exportDataToR() {
        
        let resp = data.asRData(named: "frequencies")
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
    FrequencyTable(frequencies: Frequencies.Default() )
}
