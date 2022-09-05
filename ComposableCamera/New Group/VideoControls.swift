//
//  VideoControls.swift
//  ComposableCamera
//
//  Created by Peter Larson on 9/4/22.
//

import SwiftUI

struct VideoControls: View {
    var body: some View {
        HStack(alignment: .top) {
            ToggleButton(systemName: "chevron.left")
                .foregroundColor(.darkGray)

            Spacer()
            
            VStack(spacing: 15) {
                ToggleButton(systemName: "ellipsis")
                Spacer()
                FaderView(systemName: "speaker.1.fill")
                    .frame(width: 30)
            }
            .foregroundColor(.darkGray)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
    }
}

struct VideoControls_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VideoPreview(
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
                .overlay(VideoControls())
                .padding(15/2)
        }
    }
}
