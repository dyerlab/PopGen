//
//  SwiftUIView.swift
//  
//
//  Created by Rodney Dyer on 1/22/24.
//

import SwiftUI

struct KeyValueTable: View {
    var data: [KeyValueData]
    
    var body: some View {
        Table( data ) {
            TableColumn("Parameter", value: \.label)
            TableColumn("Value") { item in
                if item.asDouble { 
                    Text(String(format: "%0.4f", item.value))
                } else {
                    Text(String(format: "%0.0f", item.value))
                }
            }
        }
    }
}

#Preview {
    KeyValueTable( data: Diversity.Default().asKeyValueData )
}
