//
//  LocusSelectorView.swift
//  
//
//  Created by Rodney Dyer on 1/26/24.
//

import SwiftUI

struct LocusSelectorView: View {
    
    var loci: [Locus]
    
    var body: some View {
        VStack {
            Text("Locus Selector")
                .font(.largeTitle)
        }
    }
}

#Preview {
    LocusSelectorView( loci: RawData.DefaultBajaLoci )
}
