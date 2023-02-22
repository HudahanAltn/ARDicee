//
//  ViewController.swift
//  ARDicee
//
//  Created by Hüdahan Altun on 21.02.2023.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!

        // Set the scene to the view
//        sceneView.scene = scene
        
        createCube()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    func createCube(){
    
        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01) // creating a new brand cube
        
        let material = SCNMaterial() //created material to give color to our cube
        
        material.diffuse.contents = UIColor.red // given color
        
        cube.materials = [material]// added color
        
        let node = SCNNode() //created a node to see in camera in realworld
        
        node.position = SCNVector3(x: 0, y: 0.1, z: -0.5) //identify position
        
        node.geometry = cube //passed cube
        
        sceneView.scene.rootNode.addChildNode(node) //add node
        sceneView.autoenablesDefaultLighting = true
        
        
    }
   
}
