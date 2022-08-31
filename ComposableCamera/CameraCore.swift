//
//  CameraCore.swift
//  ComposableCamera
//
//  Created by Peter Larson on 8/29/22.
//

import Foundation
import CoreGraphics
import VideoToolbox
import AVFoundation
import ComposableArchitecture

public struct CameraState: Equatable {
    var feed: CGImage?
    var isRecording: Bool = false
    var isBackCamera: Bool = true
}

enum CameraAction: Equatable {
    case startCamera
    case prepareDevice
    case receive(CGImage)
    case authorizationResponse(AVAuthorizationStatus)
    case toggle
    case startRecording
    case endRecording
}

struct CameraEnvironment {
    var cameraClient: CameraClient
    var session = AVCaptureSession()
    var sessionQueue = DispatchQueue(label: "com.demo.camera", qos: .userInitiated, autoreleaseFrequency: .workItem)
    var videoOutput = AVCaptureVideoDataOutput()
    var movieFileOutput = AVCaptureMovieFileOutput()
    var temporaryFileLocation: @Sendable () -> URL
}

let reducer = Reducer<CameraState, CameraAction, CameraEnvironment> {
    state, action, environment in
    
    switch action {
    case .startCamera:
        return .run { send in
            let success = await environment.cameraClient.requestAuthorization()
            
            // Handle fail
            
            //            await send(.authorizationResponse(status))
            
            //            print(status)
            
            //            guard status == .authorized else {
            //                return
            //            }
            //
            await send(.prepareDevice)
            
            for await frame in await environment.cameraClient.startFeed(environment.session, environment.videoOutput, environment.sessionQueue) {
                await send(.receive(frame))
            }
        }
    case .prepareDevice:
        return .fireAndForget {
            environment.sessionQueue.async {
                environment.session.beginConfiguration()
                
                defer {
                    environment.session.commitConfiguration()
                    environment.session.startRunning()
                }
                
                let device = AVCaptureDevice.default(
                    .builtInWideAngleCamera,
                    for: .video,
                    position: .back
                )
                
                guard let camera = device else {
                    // TODO: Handle error
                    fatalError()
                }
                
                do {
                    let cameraInput = try AVCaptureDeviceInput(device: camera)
                    
                    if environment.session.canAddInput(cameraInput) {
                        environment.session.addInput(cameraInput)
                    } else {
                        // TODO: Handle error
                        fatalError()
                    }
                } catch {
                    // TODO: Handle error
                    fatalError()
                }
                
                if environment.session.canAddOutput(environment.videoOutput) {
                    environment.session.addOutput(environment.videoOutput)
                    
                    environment.videoOutput.videoSettings = [
                        kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA
                    ]
                    
                    let videoConnection = environment.videoOutput.connection(with: .video)
                    
                    videoConnection?.videoOrientation = .portrait
                } else {
                    // TODO: Handle error
                    fatalError()
                }
            }
        }
    case .receive(let live):
        state.feed = live
        // Buffer is not being released.
        return .none
        
    case .authorizationResponse(let status):
        // TODO: Handle response
        switch status {
        default:
            return .none
        }
    case .toggle:
        
        environment.session.beginConfiguration()
        
        defer {
            environment.session.commitConfiguration()
        }
        
        guard let currentInput = environment.session.inputs.first as? AVCaptureDeviceInput else {
            fatalError()
        }
        
        guard let newCamera: AVCaptureDevice = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: currentInput.device.position == .front ? .back : .front
        ) else {
            fatalError()
        }
        
        var cameraInput: AVCaptureDeviceInput!
        
        do {
            cameraInput = try AVCaptureDeviceInput(device: newCamera)
            
            environment.session.removeInput(currentInput)
            environment.session.addInput(cameraInput)
            
            let videoConnection = environment.videoOutput.connection(with: .video)
            
            videoConnection?.videoOrientation = .portrait
        } catch {
            fatalError()
        }
        
        state.isBackCamera = newCamera.position == .back
        
        return .none
    case .startRecording:
        return .run { send in
            let file = environment.temporaryFileLocation()
            let movieFileOutput = environment.movieFileOutput
            let success = try await environment.cameraClient.startRecording(file, movieFileOutput)
        }
    case .endRecording:
        return .run { send in
            
        }
    }
}
