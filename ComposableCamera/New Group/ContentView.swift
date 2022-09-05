//
//  ContentView.swift
//  ComposableCamera
//
//  Created by Peter Larson on 9/4/22.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    let store: Store<CameraState, CameraAction>
    
    var body: some View {
        VStack(spacing: 15) {
            VideoPreview(store: store)
                .overlay(VideoControls())
            BannerView()
            ToolBar()
                .padding(.horizontal)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ContentView(
                store: .init(
                    initialState: CameraState(isRecording: true),
                    reducer: reducer.debug(),
                    environment: CameraEnvironment(
                        cameraClient: .live,
                        temporaryFileLocation: {
                            URL(fileURLWithPath: NSTemporaryDirectory())
                                .appendingPathComponent(UUID().uuidString)
                                .appendingPathExtension(".mov")
                            
                        }
                    )
                )
            )
        }
    }
}
