//
//  ContentView.swift
//  RPi GPIO AR Helper
//
//  Created by William Chilcote on 5/16/21.
//

import SwiftUI

struct ContentView: View {
    
    @State var inAR: Bool = true
    @State var selection = 0
    
    var body: some View {
        TabView (selection: $selection) {
            RealityView().ignoresSafeArea()
                .tabItem { Label("AR", systemImage: (selection == 0) ? "cube.transparent.fill" : "cube.transparent")  }.tag(0)
            FlatView().tabItem { Label("Image", systemImage: (selection == 1) ? "photo.fill" : "photo")  }.tag(1)
        }

    }
}

struct FlatView: View {
    var body: some View {
        VStack {
            Spacer()
            Image("2D Ref1").resizable().aspectRatio(contentMode: .fit)
            Spacer()
            Image("2D Ref2").resizable().aspectRatio(contentMode: .fit)
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
