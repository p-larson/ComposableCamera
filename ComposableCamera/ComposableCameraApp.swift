//
//  ComposableCameraApp.swift
//  ComposableCamera
//
//  Created by Peter Larson on 8/29/22.
//

import SwiftUI
import ComposableArchitecture

@main
struct ComposableCameraApp: App {
    var body: some Scene {
        WindowGroup {
            TabBar_Previews.previews
                .colorScheme(.dark)
//            CameraView(
//                store: .init(
//                    initialState: CameraState(isRecording: true),
//                    reducer: reducer.debug(),
//                    environment: CameraEnvironment(
//                        cameraClient: .live,
//                        temporaryFileLocation: {
//                            URL(fileURLWithPath: NSTemporaryDirectory())
//                            .appendingPathComponent(UUID().uuidString)
//                            .appendingPathExtension(".mov")
//                            
//                        }
//                    )
//                )
//            )
        }
    }
}
