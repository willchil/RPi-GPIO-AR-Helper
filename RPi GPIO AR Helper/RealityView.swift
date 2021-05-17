//
//  RealityView.swift
//  RPi GPIO AR Helper
//
//  Created by William Chilcote on 5/16/21.
//

import Foundation


import SwiftUI
import UIKit
import RealityKit
import ARKit
import Combine


struct RealityView: UIViewRepresentable {
    
    
    static let supported = ARImageTrackingConfiguration.isSupported
    
    func makeCoordinator() -> ARDelegate {
        return ARDelegate()
    }
    
    func makeUIView(context: Context) -> ARView {
        
        let view = ARView(frame: .zero)
        context.coordinator.scene = view.scene
        
        if !RealityView.supported { return view }

#if arch(arm64)

        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "Board Images", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }

        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        view.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        view.session.delegate = context.coordinator
#endif
        return view
    }
    
    func updateUIView(_ view: ARView, context: Context) {}
}
    

class ARDelegate: NSObject, ARSessionDelegate {
#if arch(arm64)

    var scene: RealityKit.Scene?

    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            guard let img = anchor as? ARImageAnchor else { continue }
            let newAnchor = ARDelegate.createRefEntity(img)
            scene?.addAnchor(newAnchor)
        }
    }

    static func createRefEntity (_ base: ARImageAnchor) -> AnchorEntity {
        let newAnchor = AnchorEntity(anchor: base)
        let width: Float = 0.055
        let planeMesh = MeshResource.generatePlane(width: width * 0.81111, depth: width)
        
        var myMaterial = UnlitMaterial()
        myMaterial.baseColor = try! .texture(.load(named: "Reference"))
        myMaterial.tintColor = UIColor.white.withAlphaComponent(0.99)
        
        let planeEntity = ModelEntity(mesh: planeMesh, materials: [myMaterial])
        newAnchor.addChild(planeEntity)
        planeEntity.transform.rotation = simd_quatf(angle: -Float.pi / 2 - 0.01, axis: simd_float3(0, 1, 0))
        planeEntity.transform.translation = simd_float3(0.0065, 0.001, -0.0310)
        planeEntity.transform.scale = simd_float3(1, 1, 1)
        return newAnchor
    }
    
#endif
}
