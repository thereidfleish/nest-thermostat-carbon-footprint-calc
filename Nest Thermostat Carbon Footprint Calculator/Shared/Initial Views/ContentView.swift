//
//  ContentView.swift
//  Shared
//
//  Created by Reid Fleishman on 3/25/22.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    @EnvironmentObject private var networkController: NetworkController
    
    var body: some View {
        TabView(selection: $selection) {
                Home()
                    .tabItem {
                        VStack {
                            Image(systemName: "house.fill")
                                .foregroundColor(.green)
                            Text("Home")
                                .foregroundColor(.green)
                        }
                    }
                    .tag(0)
            
        }/*.accentColor(Color.green)*/
    }
}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
