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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {//methos tell us touching began
        
        if let touch = touches.first{ // we take first touch from array
            
            let touchLocation = touch.location(in: sceneView)//where?
            
         
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingGeometry) //hit test

            if !results.isEmpty{
                print("touched the plane")
            }else{
                print("touch somewhere else")
            }

            if let hitResult = results.first{ // when we touch the plane then dicee will created
                
                print(hitResult)
                createDice(hitTestResult: hitResult)
            }
            
        }
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
    
    func createDice(hitTestResult:ARHitTestResult){
        
        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")
        
        if let diceNode = diceScene?.rootNode.childNode(withName: "Dice", recursively: true){
            
            diceNode.position = SCNVector3(x: hitTestResult.worldTransform.columns.3.x
                                           , y: hitTestResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius
                                           , z: hitTestResult.worldTransform.columns.3.z)
            
            sceneView.scene.rootNode.addChildNode(diceNode)
            sceneView.autoenablesDefaultLighting = true
            
            rollDice(node: diceNode)
        }
        
    }
    
    func rollDice(node:SCNNode){
        
        //we need to rotate angle
        let randomX = Float((arc4random_uniform(4) + 1)) * (Float.pi/2) // pi/2 & pi & 3pi/2 & 2pi
        
        let randomZ = Float((arc4random_uniform(4) + 1)) * (Float.pi/2) // pi/2 & pi & 3pi/2 & 2pi
    
        //rotate func
        node.runAction(
            SCNAction.rotateBy(x: CGFloat(randomX * 5), y: 0, z: CGFloat(randomZ * 5), duration: 0.5)
            
        )
        
    }

    
    

}

