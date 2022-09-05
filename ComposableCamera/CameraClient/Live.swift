//
//  Live.swift
//  ComposableCamera
//
//  Created by Peter Larson on 8/29/22.
//

import Foundation
import AVFoundation
import VideoToolbox
import ComposableArchitecture

private final class CameraDelegate: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    let continuation: AsyncStream<CGImage>.Continuation
    
    init(continuation: AsyncStream<CGImage>.Continuation) {
        self.continuation = continuation
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let imageBuffer = sampleBuffer.imageBuffer {
            var image: CGImage?
            VTCreateCGImageFromCVPixelBuffer(imageBuffer, options: nil, imageOut: &image)
            if let image = image {
                self.continuation.yield(image)
            }
        }
    }
}

private final actor Camera {
    var delegate: CameraDelegate?
    
    func startFeed(_ session: AVCaptureSession, _ output: AVCaptureVideoDataOutput, _ queue: DispatchQueue) async -> AsyncStream<CGImage> {
        session.beginConfiguration()
        
        output.setSampleBufferDelegate(self.delegate, queue: queue)
        
        defer { 
            session.commitConfiguration()
        }
        
        return AsyncStream<CGImage>(bufferingPolicy: .bufferingNewest(1)) { continuation in
            self.delegate = CameraDelegate(continuation: continuation)
        }
    }
    
    func stopFeed(_ session: AVCaptureSession, _ queue: DispatchQueue) {
        self.delegate?.continuation.finish()
        
        session.stopRunning()
    }
}

private final class RecorderDelegate: NSObject, AVCaptureFileOutputRecordingDelegate {
    let didFinishRecording: @Sendable (AVCaptureFileOutput, URL) -> Void
    
    init(didFinishRecording: @escaping @Sendable (AVCaptureFileOutput, URL) -> Void) {
        self.didFinishRecording = didFinishRecording
    }
    
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        didFinishRecording(output, outputFileURL)
    }
}

private final actor Recorder {
    var delegate: RecorderDelegate?
    
    func stopRecording(output: AVCaptureFileOutput) throws -> URL {
        output.stopRecording()
        
        guard let url = output.outputFileURL else {
            throw URLError(.badURL)
        }
        
        return url
    }
    
    func startRecording(on url: URL, output: AVCaptureMovieFileOutput) async throws -> Bool {
        let stream = AsyncThrowingStream<Bool, Error> { continuation in
            delegate = RecorderDelegate(didFinishRecording: { output, file in
                continuation.yield(true)
            })
            
            output.startRecording(to: url, recordingDelegate: delegate!)
        }
        
        guard let action = try await stream.first(where: { @Sendable _ in
            true
        }) else {
            throw CancellationError()
        }
        
        return action
        
    }
}

extension CameraClient {
    static var live: Self {
        let camera = Camera()
        let recorder = Recorder()
        
        return Self(
            requestAuthorization: {
                await AVCaptureDevice.requestAccess(for: .video)
            }, startFeed: { session, output, queue in
                await camera.startFeed(session, output, queue)
            }, startRecording: { url, movieFileOutput in
                try await recorder.startRecording(on: url, output: movieFileOutput)
            }, stopRecording: { session, movieFileOutput, queue in
                await camera.stopFeed(session, queue)
                return try await recorder.stopRecording(output: movieFileOutput)
            }
        )
    }
}
