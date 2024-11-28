import UIKit
import Vision

class PhotoLibraryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        openPhotoLibrary()
    }
    
    func openPhotoLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        processImageWithVision(image: selectedImage)
    }
    
    func processImageWithVision(image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        // Vision model
        guard let visionModel = try? VNCoreMLModel(for: MobileNetV2().model) else {
            print("Failed to load Vision model")
            return
        }
        
        let request = VNCoreMLRequest(model: visionModel) { request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                print("No results")
                return
            }
            
            DispatchQueue.main.async {
                self.showResultAlert(label: topResult.identifier)
            }
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, orientation: .up, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print("Failed to perform Vision request: \(error)")
        }
    }
    
    func showResultAlert(label: String) {
        let alert = UIAlertController(title: "Object Recognized", message: "Detected: \(label)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
}
