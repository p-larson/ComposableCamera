//
//  VideoPreview.swift
//  ComposableCamera
//
//  Created by Peter Larson on 9/4/22.
//

import SwiftUI

fileprivate func randomColor() -> Color {
    Color(
        red: .random(in: 0 ... 1), 
        green: .random(in: 0 ... 1), 
        blue: .random(in: 0 ... 1)
    )
}

import VideoPlayer
import ComposableArchitecture

struct VideoPreview: View {
    let store: Store<CameraState, CameraAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in 
            ZStack {
                if let url = viewStore.currentRecording {
                    VideoPlayer(url: url, play: .constant(true))   
                } else {
                    Color.black
                }
            }
            .cornerRadius(20)
        }
    }
}

struct VideoPreview_Previews: PreviewProvider {
    static var previews: some View {
        VideoPreview(
            store: Store(
                initialState: .init(), 
                reducer: reducer, 
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
