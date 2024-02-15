//
//  SwiftUIView.swift
//  
//
//  Created by Rodney Dyer on 1/26/24.
//

import SwiftUI

struct CircleR: View {
    
    var body: some View {
        
            Image(systemName: "r.circle")
                .font(.title3)
                .background(.clear)
                .clipShape(Circle())
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.primary, Color.accentColor)
        
    }
}

#Preview {
    CircleR()
}
