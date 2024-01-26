//
//  SwiftUIView.swift
//  
//
//  Created by Rodney Dyer on 1/26/24.
//

import SwiftUI

struct CircleR: View {
    var body: some View {
        // ZStack(alignment: .topTrailing) {
            Image(systemName: "r.circle")
                .font(.title3)
                .background(.clear)
                .clipShape(Circle())
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.primary, Color.accentColor)
            /*
            Image(systemName: "arrow.right")
                .resizable()
                .frame(width: 6, height: 6)
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.accentColor)
                .background(Color.clear)
                .rotationEffect(.degrees(-45))
                .bold()

        }
             */
    }
}

#Preview {
    CircleR()
}
