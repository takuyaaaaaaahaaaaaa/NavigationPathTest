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

struct ContentView: View {
    @StateObject var router: Router = .init()
    @State var selectedTab: BaseTab = .top
    var body: some View {
        let _ = Self._printChanges()
        TabView(selection: $selectedTab) {
            NavigationStack(path: $router.path) {
                VStack(spacing: 10) {
                    Button {
                        router.push([.child])
                    } label: {
                        Text("Push to ChildView")
                    }
                }
                .navigationDestination(for: Router.Destination.self, destination: { destination in
                    switch destination {
                    case .child:
                        ChildView()
                    }
                })
            }
            // Add animation modifier
            // because the animation of the next screen will not work after returning to the top on iOS17 and below.
            .animation(.linear, value: router.path)
            .environmentObject(router)
            .tabItem {
                Image(systemName: "house")
                Text("Top")
            }
            .tag(BaseTab.top)
        }
    }
}

struct ChildView: View {
    @EnvironmentObject private var model: Router
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
class Router: ObservableObject {
    enum Destination {
        case child
    }
    
    @Published var path: [Destination] = []

    func push(_ destinations: [Destination]) {
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
