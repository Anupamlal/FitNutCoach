//
//  BarcodeScannerView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 06/09/25.
//


import SwiftUI
import AVFoundation

struct BarcodeScannerView: UIViewRepresentable {
    
    @Binding var isSessionRunning: Bool
    var scannedCodeCallback: ((String) -> Void)?
    var metadataObjectTypes: [AVMetadataObject.ObjectType] = [
        .ean13, .ean8, .code128, .qr, .upce, .code39, .code39Mod43
    ]

    
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: BarcodeScannerView
        var captureSession: AVCaptureSession?
        
        init(parent: BarcodeScannerView) {
            self.parent = parent
        }
        
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject, let stringValue = metadataObject.stringValue, let callback = parent.scannedCodeCallback {
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                callback(stringValue)
                parent.isSessionRunning = false
                parent.stopScanning(captureSession: captureSession!)
            }
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        
        let captureSession = AVCaptureSession()
        context.coordinator.captureSession = captureSession
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return view }
        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else { return view }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: .main)
            metadataOutput.metadataObjectTypes = metadataObjectTypes
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = UIScreen.main.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        if isSessionRunning {
            startScanning(captureSession: captureSession)
        }
        
        return view
    }
    
    func startScanning(captureSession: AVCaptureSession) {
        DispatchQueue.global(qos: .userInitiated).async {
            captureSession.startRunning()
        }
    }
    
    func stopScanning(captureSession: AVCaptureSession) {
        DispatchQueue.global(qos: .userInitiated).async {
            captureSession.stopRunning()
        }
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let captureSession = context.coordinator.captureSession else { return }
        
        if isSessionRunning && !captureSession.isRunning {
            startScanning(captureSession: captureSession)
            
        }else if !isSessionRunning && captureSession.isRunning {
            stopScanning(captureSession: captureSession)
        }
    }
    
}
