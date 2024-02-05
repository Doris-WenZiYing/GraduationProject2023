//
//  QrcodeScanView.swift
//  GraduationProject2023
//
//  Created by Doris Wen on 2024/2/4.
//

import SwiftUI
import UIKit
import AVFoundation

struct ScanView: UIViewRepresentable {
    @ObservedObject var viewModel: CameraViewModel

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        viewModel.setupCaptureSession()

        let previewLayer = AVCaptureVideoPreviewLayer(session: viewModel.captureSession!)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
