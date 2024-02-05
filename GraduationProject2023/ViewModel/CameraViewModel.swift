//
//  CameraVIew.swift
//  GraduationProject2023
//
//  Created by Doris Wen on 2024/2/4.
//

import Foundation
import AVFoundation
import Vision

class CameraViewModel: NSObject, ObservableObject {
    var captureSession: AVCaptureSession?
    let logoScanModel: VNCoreMLModel
    var qrScanRequest: VNDetectBarcodesRequest?
    var logoScanRequest: VNCoreMLRequest?
    var isScanningQRCode = true


    override init() {
        guard let model = try? VNCoreMLModel(for: AdidasPO202311300002(configuration: MLModelConfiguration()).model) else {
            fatalError("Failed to load CoreML model")
        }
        self.logoScanModel = model

        super.init()
        
        self.setupDetectionRequests()
    }

    private func setupDetectionRequests() {
        // MARK: QRCode Request
        qrScanRequest = VNDetectBarcodesRequest { [weak self] request, error in
            guard let observations = request.results as? [VNBarcodeObservation], let qrcodes = observations.first else {
                print("No QR code detected.")
                return
            }
            // Handle QR code detection (e.g., switch to object detection)
            print("QRCode detected: \(qrcodes.payloadStringValue ?? "")")
            self?.isScanningQRCode = false // Assume we switch to object detection after a QR code is detected
        }

        // MARK: Logo Request
        logoScanRequest = VNCoreMLRequest(model: logoScanModel) { request, error in
            guard let results = request.results as? [VNRecognizedObjectObservation] else {
                print("Object detection failed: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            // Handle object detection results
            for observation in results {
                print("Detected object: \(observation)")
                print("Confidence: \(observation.confidence)")
            }
        }
    }

    func setupCaptureSession() {
        captureSession = AVCaptureSession()
        guard let captureSession = captureSession,
              let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let deviceInput = try? AVCaptureDeviceInput(device: device),
              captureSession.canAddInput(deviceInput) else {
            return
        }

        captureSession.addInput(deviceInput)
        let videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "VideoDataOutputQueue"))

        if captureSession.canAddOutput(videoDataOutput) {
            captureSession.addOutput(videoDataOutput)
        }

        DispatchQueue.global(qos: .background).async {
            captureSession.startRunning()
        }
    }
}
