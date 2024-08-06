//
//  ContentView.swift
//  OctoflowsDemo-SwiftUI
//
//  Created by Aleksey Goncharov on 05.08.2024.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.white

            Image("SplashIcon")
                .resizable()
                .frame(width: 200, height: 200)
                .offset(CGSize(width: 0.0, height: -100.0))
        }
    }
}

struct ContentView: View {
    var body: some View {
        ZStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                Text("Hello, world!")
            }
            .padding()

            SplashView()
        }
    }
}

#Preview {
    ContentView()
}
