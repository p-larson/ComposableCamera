//
//  TabBar.swift
//  ComposableCamera
//
//  Created by Peter Larson on 8/30/22.
//

import SwiftUI
import ComposableArchitecture


struct MainState: Equatable {
    var currentTab = Tab.explore
}

enum MainAction: Equatable {
    case select(Tab)
}

struct MainEnvironment: Equatable {
    
}

let mainReducer = Reducer<MainState, MainAction, MainEnvironment> {
    state, action, environment in
    
    switch action {
    case .select(let tab):
        
        state.currentTab = tab
        
        return .none
    }
}

enum Tab: Equatable, CaseIterable {
    case explore, camera, home
    
    var icon: String {
        switch self {
        case .explore: return "magnifyingglass"
        case .camera: return "camera"
        case .home: return "person.crop.circle"
        }
    }
    
    var title: String {
        switch self {
        case .explore: return "Explore"
        case .camera: return "Camera"
        case .home: return "My Library"
        }
    }
}


struct TabView: View {
    let store: Store<Tab, MainAction>
    let tab: Tab
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(tab.title)
                    .font(
                        .system(
                            size: 8, 
                            weight: .medium, 
                            design: .default
                        )
                    )
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .shadow(color: Color.white.opacity(0.6), radius: 10, x: 0, y: 0)
            .opacity(tab == viewStore.state ? 1.0 : 0.7)
            .onTapGesture {
                viewStore.send(MainAction.select(tab))
            }
        }
    }
}

struct TabBar: View {
    let store: Store<MainState, MainAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            HStack {
                ForEach(Array(Tab.allCases.enumerated()), id: \.element) { offset, tab in
                    TabView(store: store.scope(state: \.currentTab), tab: tab)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 12)
            .frame(height: 82, alignment: .top)
            .background(Color.black)
            .overlay {
                Rectangle()
                    .fill(Material.regular)
                    .opacity(0.5)
                    .frame(height: 0.5)
                    .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    }
}

struct MainView: View {
    let store: Store<MainState, MainAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(spacing: 0) {
                switch viewStore.currentTab {
                case .camera: CameraView(
                    store: Store(
                        initialState: CameraState(), 
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
                default: Spacer()
                }
                TabBar(store: store)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        MainView(
            store: Store(
                initialState: MainState(), 
                reducer: mainReducer.debug(), 
                environment: MainEnvironment()
            )
        )
    }
}
