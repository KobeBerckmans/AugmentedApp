import SwiftUI
import ARKit
import RealityKit
import Vision

struct ARViewContainer: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ViewController {
        return ViewController() // Jouw UIKit ViewController
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        // Update logic if needed
    }
}
