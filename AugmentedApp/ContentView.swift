//
//  ContentView.swift
//  AugmentedApp
//
//  Created by Kobe Berckmans on 26/11/2024.
//
import SwiftUI

struct ContentView: View {
    var body: some View {
        MainARViewContainer()  // De AR-view wordt hier getoond
            .edgesIgnoringSafeArea(.all)
    }
}

struct MainARViewContainer: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ViewController {
        return ViewController()  // Dit maakt de ViewController voor AR
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        // Hier kun je logica toevoegen om de ViewController bij te werken, als dat nodig is
    }
}
