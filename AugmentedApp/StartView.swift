//
//  StartView.swift
//  AugmentedApp
//
//  Created by Kobe Berckmans on 27/11/2024.
//

import SwiftUI

struct StartView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to Augmented App")
                .font(.largeTitle)
                .padding()
            
            // Knop om AR Camera te openen
            Button(action: {
                let arViewController = ViewController()
                arViewController.modalPresentationStyle = .fullScreen
                UIApplication.shared.windows.first?.rootViewController?.present(arViewController, animated: true, completion: nil)
            }) {
                Text("Open AR Camera")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
            
            // Knop om Photo Library te openen
            Button(action: {
                let photoLibraryViewController = PhotoLibraryViewController()
                photoLibraryViewController.modalPresentationStyle = .fullScreen
                UIApplication.shared.windows.first?.rootViewController?.present(photoLibraryViewController, animated: true, completion: nil)
            }) {
                Text("Open Photo Library")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
        }
    }
}

