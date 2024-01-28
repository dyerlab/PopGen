//
//  DataColumnsView.swift
//
//
//  Created by Rodney Dyer on 1/28/24.
//

import SwiftUI

struct CSVInputFileView: View {
    @State var dataColumns = DataColumns()
    @State var filePath: String = "no file selected"
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text("Raw Data File:")
                Text(filePath)
                    .frame(minWidth: 200)
                Button(action: {
                    print("look for file")
                }, label: {
                    Text("Find")
                })
                .disabled( filePath != "no file selected" )
            }
        }
        .padding()
    }
    
    
    
    
}

#Preview {
    CSVInputFileView()
}
