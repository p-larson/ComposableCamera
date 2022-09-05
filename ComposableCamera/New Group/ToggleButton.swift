//
//  ToggleButton.swift
//  ComposableCamera
//
//  Created by Peter Larson on 9/4/22.
//

import SwiftUI

struct ToggleButton: View {
    let systemName: String
    
    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .scaledToFit()
            .font(.system(size: 16, weight: .heavy, design: .default))
            .foregroundColor(.white)
            .frame(width: 16, height: 16)
            .frame(width: 45, height: 45)
            .background(
                Circle()
            )
    }
}

struct ToggleButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ToggleButton(systemName: "checkmark")
                .foregroundColor(.green)
            
            ToggleButton(systemName: "ellipsis")
                .foregroundColor(.darkGray)
        }
    }
}
