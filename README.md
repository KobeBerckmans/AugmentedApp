# Augmented Reality Object Recognition App

This iOS application combines **Augmented Reality (AR)** and **CoreML-based object recognition**. Users can interact with their surroundings through AR or select a photo from their library for object detection.

---

## Features

### 🎥 AR Object Recognition
- Open the AR camera to detect and recognize objects in real-time.
- Identified objects are displayed as animated 3D text in the AR scene.

### 📷 Photo Library Detection
- Select a photo from your library to detect and recognize the main object in the image.
- Object names are displayed for the selected photo.

### ✨ User-Friendly Start Screen
- A clean and interactive start screen with buttons to access the AR camera or the photo library.

---

## Requirements

- **iOS 15.0+**
- Xcode 15.2 or higher
- A device with ARKit support

---

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/ar-object-recognition.git
open AugmentedApp.xcodeproj

Make sure the deployment target is set to a compatible device.
Run the app on a physical device (ARKit does not work on the simulator).

Configuration
Permissions
Ensure the app has the necessary permissions in the Info.plist file:

For AR camera access:
xml
Copy code
NSCameraUsageDescription
This app requires camera access for AR functionality.</
For Photo Library access:
xml
Copy code
NSPhotoLibraryUsageDescription
This app requires access to your photo library to analyze images.

How It Works
AR Camera:

Tap "Open Camera" on the start screen.
Point your camera at objects to recognize them.
The app uses Vision and CoreML to detect objects and display their names in AR.
Photo Library:

Tap "Open Photo Library" on the start screen.
Select an image from your library.
The app processes the image and displays the name of the detected object.
Technologies Used
Swift: Primary programming language
ARKit: For creating AR experiences
Vision: For image recognition
CoreML: Using the MobileNetV2 model for object detection
SwiftUI: For the start screen interface
Known Issues
AR object detection accuracy depends on lighting and object clarity.
Photo Library recognition may not work well with cluttered images or unsupported objects.
Future Improvements
Add support for custom CoreML models.
Enhance AR animations for better user feedback.
Allow saving recognized objects to a database.
