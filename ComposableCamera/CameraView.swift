//
//  ContentView.swift
//  ComposableCamera
//
//  Created by Peter Larson on 8/29/22.
//

import SwiftUI
import ComposableArchitecture

public struct CameraView: View {
    let store: Store<CameraState, CameraAction>
    
    public var body: some View {
        WithViewStore(self.store) { viewStore in
            if let image = viewStore.feed {
                GeometryReader { geometry in
                    Image(decorative: image, scale: 1.0, orientation: viewStore.isBackCamera ? .up : .upMirrored)
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.height,
                            alignment: .center
                        )
                        .clipped()
                }
                .onTapGesture(count: 2) {
                    viewStore.send(.toggle)
                }
            } else {
                Color.black.onAppear(perform: {
                    viewStore.send(.startCamera)
                })
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
