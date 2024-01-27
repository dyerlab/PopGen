//
//  SwiftUIView.swift
//  
//
//  Created by Rodney Dyer on 1/26/24.
//

import SwiftUI

struct AMOVATable: View {
    var title: String
    var data: [AMOVAData]
    
    var body: some View {
        VStack(alignment:.leading) {
            Text(title)
                .font(.title2)
 
            Table(data) {
                TableColumn("Source", value: \.source)
                TableColumn("df") { item in
                    Text("\(item.df)")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                TableColumn("Sums of Squares") { item in
                    Text("\(item.SS)")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                TableColumn("Mean Squares") { item in
                    if let ms = item.MS {
                        Text(String(format: "%0.4f", ms))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    } else {
                        Text("")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }

                }
            }
            .cornerRadius(5.0)
            
        }
        .padding()
 
    }
}

#Preview {
    VStack {
        AMOVATable( title: String("Analysis of MOlecular VAriance (AMOVA) decomposition of genetic variance at the WNT locus."),
                    data: WierCockerham.DefaultWC.asAMOVAData )
        AMOVATable( title: String("Analysis of MOlecular VAriance (AMOVA) decomposition of genetic variance at the all loci."),
                    data: WierCockerham.DefaultAMOVA.asAMOVAData )

    }
    .frame( minHeight: 600)
}
