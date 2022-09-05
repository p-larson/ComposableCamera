//
//  FaderView.swift
//  ComposableCamera
//
//  Created by Peter Larson on 9/1/22.
//

import SwiftUI

struct FaderView: View {
    let systemName: String
    
    @State private var value: CGFloat = .zero
    
    var body: some View {
        GeometryReader { reader in 
            Group {
                Rectangle()
                    .fill(Color.darkGray)
                Rectangle()
                    .foregroundColor(.white)
                    .frame(height: value * reader.size.height)
                    .frame(height: reader.size.height, alignment: .bottom)
                    .shadow(color: .white, radius: 10, x: 0, y: 0)
                Image(systemName: systemName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .padding(.bottom)
                    .frame(width: reader.size.width, height: reader.size.height, alignment: .bottom)
                    .foregroundColor(Color.black.opacity(0.3))
            }
            .gesture(
                DragGesture(minimumDistance: 0.0, coordinateSpace: .local)
                    .onChanged({ value in
                        self.value = (reader.size.height - value.location.y) / reader.size.height
                    })
            )
        }
        .aspectRatio(
            CGSize(
                width: 6, 
                height: 31
            ), 
            contentMode: .fit
        )
        .cornerRadius(20)
        .clipped()
        
    }
}

struct FaderView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            HStack {
                FaderView(systemName: "speaker.3.fill")
            }
            .frame(height: 155)
        }
        
    }
}
