//
//  Camera+Extensions.swift
//  GraduationProject2023
//
//  Created by Doris Wen on 2024/2/5.
//

import AVFoundation
import Vision


extension CameraViewModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])

        do {
            if isScanningQRCode {
                try imageRequestHandler.perform([qrScanRequest].compactMap { $0 })
            } else {
                try imageRequestHandler.perform([logoScanRequest].compactMap { $0 })
            }
        } catch {
            print("Failed to perform request: \(error.localizedDescription)")
        }
    }
}
