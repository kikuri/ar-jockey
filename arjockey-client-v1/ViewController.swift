//
//  ViewController.swift
//  arjockey-client-v1
//
//  Created by kikuchi wataru on 2018/01/24.
//  Copyright © 2018年 kikuchi wataru. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation

class ViewController: UIViewController, ARSCNViewDelegate, AVAudioPlayerDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var source: SCNAudioSource?
    
    var shipNode = SCNNode()
    
    var timer: Timer!
    
    let label = UILabel()
    
    var audioPlayer:AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
//        source = SCNAudioSource(fileNamed: "art.scnassets/ping.aif")!
//        source!.loops = true
//        source!.load()
//
        let audioPath = Bundle.main.path(forResource: "sound", ofType:"mp3")!
        let audioUrl = URL(fileURLWithPath: audioPath)
        
        var audioError:NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
        } catch let error as NSError {
            audioError = error
            audioPlayer = nil
        }
  
        if let error = audioError {
            print("Error \(error.localizedDescription)")
        }
        
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
        
//        playSound()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
        
        timer.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    @objc func update(tm: Timer) {
        let hitResults = sceneView.hitTest(sceneView.center, types: [.featurePoint])
        if !hitResults.isEmpty {
            if let hitResult = hitResults.first {
                let center = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
                var distanceString = String.init(format: "%.2f", arguments: [hitResult.distance])
                var distance = Float(distanceString)
                print(distance)
                
                if distance! < Float(0.3)  {
                     print(true)
                     audioPlayer.play()
                } else {
                     print(false)
                     audioPlayer.stop()
                }
            }
        }
    }
    
//    func playSound() {
//        guard shipNode.audioPlayers.count == 0 else { return }
//        shipNode.addAudioPlayer(SCNAudioPlayer(source: source!))
//    }
    
}
