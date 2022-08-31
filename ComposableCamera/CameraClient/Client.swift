//
//  Client.swift
//  ComposableCamera
//
//  Created by Peter Larson on 8/29/22.
//

import Foundation
import CoreGraphics
import AVFoundation
import ComposableArchitecture

struct CameraClient {
    var requestAuthorization: @Sendable () async -> Bool
    var startFeed: @Sendable (AVCaptureSession, AVCaptureVideoDataOutput, DispatchQueue) async -> AsyncStream<CGImage>
    var startRecording: @Sendable (URL, AVCaptureMovieFileOutput) async throws -> Bool
    var stopRecording: @Sendable () async -> (URL)
}
