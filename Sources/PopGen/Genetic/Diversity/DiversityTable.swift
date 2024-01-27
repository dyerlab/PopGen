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
        KeyValueTable(title: String("Genetic Diversity: \(diversity.locus)"),
                      data: diversity.toKeyValueData(grouped: false) )
    }
}

#Preview {
    DiversityTable( diversity: Diversity.Default() )
}
