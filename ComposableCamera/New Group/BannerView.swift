//
//  BannerView.swift
//  ComposableCamera
//
//  Created by Peter Larson on 9/4/22.
//

import SwiftUI

fileprivate struct SearchingView: View {
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "waveform.and.magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
            
            Text("Searching for your Wimyx")
                .font(.system(size: 16, weight: .semibold, design: .default))
                .frame(maxWidth: .infinity, alignment: .leading)
                .opacity(0.7)
            
            Image(systemName: "xmark")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .opacity(0.3)
        }
    }
}

struct SuggestedModel: Equatable, Hashable {
    let artist: String
}

fileprivate struct SuggestedView: View {
    let model: SuggestedModel
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "waveform.and.magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
            
            VStack(alignment: .leading) {
                Text("Suggested Wimyx")
                    .textCase(.uppercase)
                    .font(.system(size: 12, weight: .semibold))
                    .opacity(0.7)
                Text(model.artist)
                    .font(.system(size: 16, weight: .semibold))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
            ActionButton(title: "Download")
        }
    }
}

enum DownloadStatus: Equatable, Hashable {
    case paused
    case downloading(Double)
}

fileprivate struct DownloadStatusView: View {
    let state: DownloadStatus
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    style: state == .paused ? StrokeStyle(
                        lineWidth: 2, 
                        dash: [4], 
                        dashPhase: 0
                    ) : StrokeStyle(lineWidth: 2)
                )
                .foregroundColor(.white)
                .opacity(state == .paused ? 1 : 0.1)
            
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 10, height: 10)
            
            if case .downloading(let progress) = state {
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(lineWidth: 2)
                    .rotation(.degrees(-90))
                    .foregroundColor(.white)
            }
        }
        .frame(width: 30, height: 30)
    }
}

fileprivate struct DownloadingView: View {
    let model: SuggestedModel
    let state: DownloadStatus
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "waveform.and.magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
            
            VStack(alignment: .leading) {
                Text("Downloading...")
                    .textCase(.uppercase)
                    .font(.system(size: 12, weight: .semibold))
                    .opacity(0.7)
                    .lineLimit(1)
                Text(model.artist)
                    .font(.system(size: 16, weight: .semibold))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            DownloadStatusView(state: state)
        }
    }
}


fileprivate struct FailedConnectionView: View {
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "wifi.exclamationmark")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
            
            VStack(alignment: .leading) {
                Text("No Internet")
                    .textCase(.uppercase)
                    .font(.system(size: 12, weight: .semibold))
                    .opacity(0.7)
                    .lineLimit(1)
                Text("Couldn't find Mix")
                    .lineLimit(1)
                    .font(.system(size: 16, weight: .semibold))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            ActionButton(title: "Retry")
        }
    }
}

struct WimyxSnippetModel: Equatable, Hashable {
    let artist: String
    let data: Data? = nil
}

fileprivate struct WimyxPreview: View {
    let model: WimyxSnippetModel
    
    var body: some View {
        HStack {
            
        }
    }
}

struct BannerView: View {
    let state: State

    public enum State: Equatable, Hashable {
        case searching
        case suggested(SuggestedModel)
        case downloading(SuggestedModel, DownloadStatus)
        case failedConnection
        case ready(WimyxSnippetModel)
    }
    
    public init(state: State = .searching) {
        self.state = state
    }
    
    var body: some View {
        Group {
            switch state {
            case .searching:
                SearchingView()
            case .suggested(let model):
                SuggestedView(model: model)
            case .downloading(let model, let state):
                DownloadingView(model: model, state: state)
            case .failedConnection:
                FailedConnectionView()
            case .ready(let model):
                WimyxPreview(model: model)
            }
        }
        .foregroundColor(.white)
        .padding(.horizontal, 30)
        .frame(maxWidth: .infinity)
        .frame(height: 70)
        .background(
        	RoundedRectangle(cornerRadius: 15)
                .fill(Color.darkGray)
        )
    }
}

struct BannerView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            VStack {
                ForEach([
                    BannerView.State.searching,
                    BannerView.State.suggested(
                        SuggestedModel(
                            artist: "Kanye West"
                        )
                    ),
                    BannerView.State.downloading(
                        SuggestedModel(
                            artist: "Kanye West"
                        ),
                        DownloadStatus.paused
                    ),
                    BannerView.State.downloading(
                        SuggestedModel(
                            artist: "Kanye West"
                        ),
                        DownloadStatus.downloading(0.5)
                    ),
                    BannerView.State.failedConnection
                ], id: \.self) { state in
                    BannerView(state: state)
                }
            }
        }
    }
}
