//
//  DiversityTable.swift
//  
//
//  Created by Rodney Dyer on 1/22/24.
//

import SwiftUI

struct DiversityTable: View {

    let diversity: Diversity
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Genetic Diversity: \(diversity.locus)")
                .font(.title2)
            KeyValueTable(data: diversity.toKeyValueData(grouped: false) )
        }
        .padding()
    }
}

#Preview {
    DiversityTable( diversity: Diversity.Default() )
}
