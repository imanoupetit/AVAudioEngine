
/**
 Source: http://stackoverflow.com/questions/30679061/can-i-use-avaudioengine-to-read-from-a-file-process-with-an-audio-unit-and-writ
 Converted from Obj-C to Swift 3
 */

import UIKit
import AVFoundation

class ViewController6: UIViewController {

    // engine and playerNode has to be properties, not method scoped variables
    let engine = AVAudioEngine()
    let playerNode = AVAudioPlayerNode()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "VC6"
        
        engine.attach(playerNode)
        
        let mixer = engine.mainMixerNode
        engine.connect(playerNode, to: mixer, format: mixer.outputFormat(forBus: 0))
        
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
    
}


class ViewController7: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "VC6"
        
        let engine = AVAudioEngine()
        let playerNode = AVAudioPlayerNode()
        engine.attach(playerNode)
        
        guard let url = Bundle.main.url(forResource: "drumLoop", withExtension: "caf") else { return }
        let file = try! AVAudioFile(forReading: url)
        
        let mixer = engine.mainMixerNode
        engine.connect(playerNode, to: mixer, format: file.processingFormat)
        
        playerNode.scheduleFile(file, at: nil, completionHandler: nil)
        playerNode.play()
        
        // Start engine
        do {
            try engine.start()
        } catch {
            assertionFailure("AVAudioEngine start error: \(error)")
        }
    }
    
}

