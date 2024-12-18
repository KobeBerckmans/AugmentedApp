import UIKit
import RealityKit
import Vision
import ARKit

class ViewController: UIViewController {
    var arView: ARView!
    
    // Vision model
    private var visionRequests = [VNRequest]()
    private let dispatchQueue = DispatchQueue(label: "com.arobjectrecognition.queue")
    
    // Huidig AR-anchor
    private var currentAnchor: AnchorEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize ARView
        arView = ARView(frame: self.view.bounds)
        self.view.addSubview(arView)
        
        // Start AR session
        startARSession()
        
        // Setup Vision for object detection
        setupVision()
    }
    
    func startARSession() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        
        // Run AR session with configuration
        arView.session.run(config)
    }
    
    func setupVision() {
        // Load the CoreML model
        guard let visionModel = try? VNCoreMLModel(for: MobileNetV2().model) else {
            fatalError("Failed to load Vision model")
        }
        
        // Setup Vision request
        let request = VNCoreMLRequest(model: visionModel) { [weak self] request, error in
            self?.handleVisionRequest(request: request, error: error)
        }
        request.imageCropAndScaleOption = .centerCrop
        visionRequests = [request]
    }
    
    func handleVisionRequest(request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNClassificationObservation],
              let topResult = results.first else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.addARContent(label: topResult.identifier)
        }
    }
    
    func addARContent(label: String) {
        // Verwijder het vorige anker indien aanwezig
        if let existingAnchor = currentAnchor {
            arView.scene.removeAnchor(existingAnchor)
        }
        
        // Maak een 3D tekst entiteit
        let textMesh = MeshResource.generateText(label,
                                                 extrusionDepth: 0.05,
                                                 font: .systemFont(ofSize: 0.2),
                                                 containerFrame: .zero,
                                                 alignment: .center,
                                                 lineBreakMode: .byWordWrapping)
        
        let textMaterial = SimpleMaterial(color: .red, isMetallic: true)
        let textEntity = ModelEntity(mesh: textMesh, materials: [textMaterial])
        textEntity.scale = [0.1, 0.1, 0.1] // Start kleiner
        
        // Voeg het tekstobject toe aan een AR-anker
        let anchor = AnchorEntity(world: [0, 0, -0.5])
        anchor.addChild(textEntity)
        arView.scene.addAnchor(anchor)
        
        // Bewaar het nieuwe anker als het huidige anker
        currentAnchor = anchor
        
        // Maak de animatie vloeiender en beweeg de tekst langzaam in het zicht
        let initialPosition = SIMD3<Float>(0, 0, -0.8)  // Begin iets verder van de camera af
        let finalPosition = SIMD3<Float>(0, 0, -1.5)   // Eindpositie dichterbij

        // Voeg een animatie toe
        let animationDuration: TimeInterval = 1.0
        var transform = textEntity.transform
        transform.translation = initialPosition  // Start de animatie buiten het zicht

        // Zet de tekst langzaam naar de eindpositie
        textEntity.move(to: Transform(translation: finalPosition), relativeTo: nil, duration: animationDuration)
        
        // Animatie is klaar, dan de uiteindelijke transform
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            print("Animatie voltooid")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Verwerk de camera frame voor Vision
        guard let currentFrame = arView.session.currentFrame else { return }
        let pixelBuffer = currentFrame.capturedImage
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right, options: [:])
        dispatchQueue.async {
            do {
                try handler.perform(self.visionRequests)
            } catch {
                print("Failed to perform Vision request: \(error)")
            }
        }
    }
}

