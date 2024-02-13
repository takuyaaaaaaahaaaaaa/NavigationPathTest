//
// ContentView.swift
// SampleView
//
// Created by 冨永 拓弥 on 2023/09/11.
//

import SwiftUI

enum BaseTab {
    case top
}

enum PushDestination {
    case child
}

struct ContentView: View {
    @StateObject var navigationModel: NavigationModel = .init()
    @State var selectedTab: BaseTab = .top
    var body: some View {
        let _ = Self._printChanges()
        TabView(selection: $selectedTab) {
            NavigationStack(path: $navigationModel.path) {
                VStack(spacing: 10) {
                    Button {
                        navigationModel.push([.child])
                    } label: {
                        Text("Push to ChildView")
                    }
                }
                .navigationDestination(for: PushDestination.self, destination: { destination in
                    switch destination {
                    case .child:
                        ChildView()
                    }
                })
            }
            // Add animation modifier
            // because the animation of the next screen will not work after returning to the top on iOS17 and below.
            .animation(.linear, value: navigationModel.path)
            .environmentObject(navigationModel)
            .tabItem {
                Image(systemName: "house")
                Text("Top")
            }
            .tag(BaseTab.top)
        }
    }
}

struct ChildView: View {
    @EnvironmentObject private var model: NavigationModel
    var body: some View {
        VStack {
            Button {
                model.push([.child])
            } label: {
                Text("Child View")
            }
            Button {
                model.popToTop()
            } label: {
                Text("Return to Top")
            }
            Text("\(model.path.count)Views are Stacked")
        }
    }
}

/// Navigation遷移モデル
class NavigationModel: ObservableObject {
    @Published var path: [PushDestination] = []

    func push(_ destinations: [PushDestination]) {
        path.append(contentsOf: destinations)
    }

    func pop() {
        path.removeLast()
    }

    func popToTop() {
        // Add animation modifier
        // because the animation of the next screen will not work after returning to the top on iOS17 and below.
        if #unavailable(iOS 17) {
            withAnimation(.linear(duration: 0)) {
                path.removeAll()
            }
        } else {
            path.removeAll()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
