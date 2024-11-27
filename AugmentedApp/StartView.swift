//
//  StartView.swift
//  AugmentedApp
//
//  Created by Kobe Berckmans on 27/11/2024.
//

import SwiftUI

struct StartView: View {
    var body: some View {
        NavigationView {  // Zorg ervoor dat je een NavigationView gebruikt voor de navigatie
            VStack {
                Text("Welcome to AR App")
                    .font(.largeTitle)
                    .padding()
                
                NavigationLink(destination: ContentView()) {  // Deze navigatie link brengt je naar ContentView
                    Text("Open Camera")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Start")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
