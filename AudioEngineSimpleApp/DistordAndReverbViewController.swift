
/**
 Source: https://github.com/arielelkin/SwiftyAudio
 Converted to Swift 3
 */

import UIKit
import AVFoundation

class DistordAndReverbViewController: UIViewController {
    
    let engine = AVAudioEngine()
    let distortion = AVAudioUnitDistortion()
    let reverb = AVAudioUnitReverb()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup AVAudioSession
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            let ioBufferDuration = 0.005
            try AVAudioSession.sharedInstance().setPreferredIOBufferDuration(ioBufferDuration)
        } catch {
            assertionFailure("AVAudioSession setup error: \(error)")
        }
        
        // Setup engine and node instances
        assert(engine.inputNode != nil)
        let input = engine.inputNode!
        let output = engine.outputNode
        let format = input.inputFormat(forBus: 0)
        
        distortion.loadFactoryPreset(.drumsBitBrush)
        distortion.preGain = -6
        engine.attach(distortion)
        
        reverb.loadFactoryPreset(.mediumRoom)
        reverb.wetDryMix = 80
        engine.attach(reverb)
        
        // Connect nodes
        engine.connect(input, to: distortion, format: format)
        engine.connect(distortion, to: reverb, format: format)
        engine.connect(reverb, to: output, format: format)
        
        // Start engine
        do {
            try engine.start()
        } catch {
            assertionFailure("AVAudioEngine start error: \(error)")
        }
    }
    
}
