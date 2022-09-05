//
//  DetailToggleButtoin.swift
//  ComposableCamera
//
//  Created by Peter Larson on 9/4/22.
//

import SwiftUI

struct DetailToggleButton: View {
    let systemName: String
    let label: String
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: systemName)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .font(.system(size: 20, weight: .bold, design: .default))
            Text(label)
                .font(.system(size: 16, weight: .bold, design: .default))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .foregroundColor(.white)
        .frame(height: 45)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal)
        .background(
            Capsule(style: .circular)
        )
    }
}

struct DetailToggleButtoin_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 15) {
            DetailToggleButton(
                systemName: "ear.and.waveform", 
                label: "Original"
            )
            .foregroundColor(.darkGray)
            
            
            DetailToggleButton(
                systemName: "ear.and.waveform", 
                label: "Auto"
            )
            .foregroundColor(.blue)            
        }
        .padding(.trailing, 100)
    }
}
