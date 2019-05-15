//
//  ViewController.swift
//  IOS-Swift-ARKitFaceTracking01
//
//  Created by sun on 15/5/2562 BE.
//  Copyright © 2562 sun. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Face tracking is not supported on this device")
        }
        
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let config = ARFaceTrackingConfiguration()
        sceneView.session.run(config)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }


}

extension ViewController: ARSCNViewDelegate {
    // create faceTracking
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        var device: MTLDevice!
        device = MTLCreateSystemDefaultDevice()
        
        let faceGrometry = ARSCNFaceGeometry(device: device)
        let node = SCNNode(geometry: faceGrometry)
        
        node.geometry?.firstMaterial?.fillMode = .lines
        node.geometry?.firstMaterial?.colorBufferWriteMask = SCNColorMask.blue
        
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        guard let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
            return
        }
        // update face tracking
        faceGeometry.update(from: faceAnchor.geometry)
    }
    
    
}
