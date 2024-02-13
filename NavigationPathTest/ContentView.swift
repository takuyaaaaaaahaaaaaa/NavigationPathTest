//
// ContentView.swift
// SampleView
//
// Created by 冨永 拓弥 on 2023/09/11.
//

import SwiftUI

struct ContentView: View {
    @StateObject var router: Router = .init()
    var body: some View {
        TabView {
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
            // ⭐️ Add animation modifier
            // because the animation of the next screen will not work after returning to the top on iOS17 and below.
            .animation(.default, value: router.path)
            .environmentObject(router)
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
