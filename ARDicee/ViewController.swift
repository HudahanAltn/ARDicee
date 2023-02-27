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
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!

        // Set the scene to the view
//        sceneView.scene = scene
        

//        createDice()
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        configuration.planeDetection = .horizontal //detect horizontal surface
        
    
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

  
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {//we take the detected surface as anchor
        
        if anchor is ARPlaneAnchor{// we need planeAnchor because we want to detect horizontal surface
            
            print("plane detected")
            
            let planeAnchor = anchor as! ARPlaneAnchor //casting
            
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))// created plane to fit which detected surface
            
            let planeNode = SCNNode()
            
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)// set node position
            
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)// we need to transform because detected surface is horizontal but plane is vertical
            
            let gridMaterial =  SCNMaterial()
            
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            
            plane.materials = [gridMaterial]
            
            planeNode.geometry = plane
            
            
        
            node.addChildNode(planeNode)
            
        }else{
            print("plane not detected")
            return
        }
        
    }
        

}

extension ViewController{
    
    func createDice(){
        
        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")
        
        if let diceNode = diceScene?.rootNode.childNode(withName: "Dice", recursively: true){
            
            diceNode.position = SCNVector3(x: 0, y: 0.1, z: -0.1)
            
            sceneView.scene.rootNode.addChildNode(diceNode)
            sceneView.autoenablesDefaultLighting = true
        }
        
        
    
    }

}

