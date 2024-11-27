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
        
        // Create a 3D text entity
        let textMesh = MeshResource.generateText(label,
                                                 extrusionDepth: 0.05,
                                                 font: .systemFont(ofSize: 0.2),
                                                 containerFrame: .zero,
                                                 alignment: .center,
                                                 lineBreakMode: .byWordWrapping)
        
        let textMaterial = SimpleMaterial(color: .red, isMetallic: true)
        let textEntity = ModelEntity(mesh: textMesh, materials: [textMaterial])
        textEntity.position = [0, 0, -0.5] // Place 50 cm in front of the camera
        
        // Add the text entity to the AR scene
        let anchor = AnchorEntity(world: [0, 0, -0.5])
        anchor.addChild(textEntity)
        arView.scene.addAnchor(anchor)
        
        // Bewaar het nieuwe anker als het huidige anker
        currentAnchor = anchor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Process camera frame for Vision
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
