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
        TabView(selection: tabSelection()) {
            NavigationStack(path: $navigationModel.path) {
                VStack(spacing: 10) {
                    Button {
                        navigationModel.push(.child)
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
            .environmentObject(navigationModel)
            .tabItem {
                Image(systemName: "return")
                Text("Return Top")
            }
            .tag(BaseTab.top)
        }
    }

    /// タブダブルタップ時に初期画面に遷移
    private func tabSelection() -> Binding<BaseTab> {
        Binding {
            selectedTab
        } set: { tappedTab in
            if tappedTab == selectedTab {
                switch tappedTab {
                case .top:
                    navigationModel.popToTop()
                }
            }
            selectedTab = tappedTab
        }
    }
}

struct ChildView: View {
    @EnvironmentObject private var model: NavigationModel
    var body: some View {
        VStack {
            Button {
                model.push(.child)
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

    func push(_ destination: PushDestination) {
        path.append(destination)
    }

    func pop() {
        path.removeLast()
    }

    func popToTop() {
        path = []
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
