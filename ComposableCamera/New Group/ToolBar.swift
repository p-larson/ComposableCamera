//
//  ToolBar.swift
//  ComposableCamera
//
//  Created by Peter Larson on 9/4/22.
//

import SwiftUI

struct ToolBar: View {
    
    var body: some View {
        HStack(spacing: 10) {
            DetailToggleButton(
                systemName: "ear.and.waveform", 
                label: "Original"
            )
            
            DetailToggleButton(
                systemName: "ear.and.waveform", 
                label: "Auto"
            )
            .foregroundColor(.blue)
            
            ToggleButton(systemName: "waveform.and.magnifyingglass")
            ToggleButton(systemName: "arrow.right")
                .foregroundColor(.black)
                .colorInvert()
        }
        .foregroundColor(.darkGray)
        .frame(height: 80, alignment: .top)
    }
}

struct ToolBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ToolBar()
                .padding(.horizontal)
        }
    }
}
