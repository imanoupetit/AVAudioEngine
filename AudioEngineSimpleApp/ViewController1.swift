
/**
 Source: http://stackoverflow.com/questions/30679061/can-i-use-avaudioengine-to-read-from-a-file-process-with-an-audio-unit-and-writ
 Converted from Obj-C to Swift 3
 */

import UIKit
import AVFoundation

class ViewController1: UIViewController {
    
    var engine = AVAudioEngine()
    let playerNode = AVAudioPlayerNode()
    var distortionEffect = AVAudioUnitDistortion()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        engine.attach(playerNode)
        engine.attach(distortionEffect)
        
        // Connect nodes
        engine.connect(playerNode, to: distortionEffect, format: distortionEffect.outputFormat(forBus: 0))
        let mixer = engine.mainMixerNode
        engine.connect(distortionEffect, to: mixer, format: mixer.outputFormat(forBus: 0))
        distortionEffect.loadFactoryPreset(.drumsBitBrush)

        // Start engine
        do {
            try engine.start()
        } catch {
            assertionFailure("AVAudioEngine start error: \(error)")
        }
        
        guard let url = Bundle.main.url(forResource: "drumLoop", withExtension: "caf") else { return }
        do {
            let file = try AVAudioFile(forReading: url)
            playerNode.scheduleFile(file, at: nil, completionHandler: nil)
            playerNode.play()
        } catch {
            assertionFailure("Error: \(error)")
        }
    }
    
    @IBAction func stop(_ sender: UIButton) {
        engine.stop()
    }
    
}
