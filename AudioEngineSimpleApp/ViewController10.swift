
import UIKit
import AVFoundation

class ViewController10: UIViewController {
    
    // engine and playerNode has to be properties, not method scoped variables
    let engine = AVAudioEngine()
    let playerNode = AVAudioPlayerNode()
    @IBOutlet var recordButton : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "VC10"
        
        engine.attach(playerNode)
        
        let mixer = engine.mainMixerNode
        engine.connect(playerNode, to: mixer, format: mixer.outputFormat(forBus: 0))
        
        guard let url = Bundle.main.url(forResource: "drumLoop", withExtension: "caf") else { return }
        do {
            let file = try AVAudioFile(forReading: url)
            let closure = { [unowned self] () -> Void in
                DispatchQueue.main.async {
                    self.engine.stop()
                    
                    guard let inputNode = self.engine.inputNode else { fatalError("Audio engine has no input node") }
                    inputNode.removeTap(onBus: 0)
                    
                    self.recordButton.isEnabled = true
                    self.recordButton.setTitle("Start Recording", for: [])
                }
            }
            playerNode.scheduleFile(file, at: nil, completionHandler: closure)
        } catch {
            assertionFailure("Error: \(error)")
        }
    }

    // MARK: - Custom methods
    
    var val = 0
    
    private func startRecording() throws {
        //guard let inputNode = audioEngine.inputNode else { fatalError("Audio engine has no input node") }
        //let originNode = playerNode
        let originNode = engine.mainMixerNode
        
        let recordingFormat = originNode.outputFormat(forBus: 0)
        originNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            /* Do stuff here */
            DispatchQueue.main.async {
                self.val += 1
                print(self.val, buffer)
            }
        }
        
        engine.prepare()
        try engine.start()
        playerNode.play()
    }
    
    // MARK: Interface Builder actions
    
    @IBAction func stopProcess() {
        self.engine.stop()
        
        guard let inputNode = engine.inputNode else { fatalError("Audio engine has no input node") }
        inputNode.removeTap(onBus: 0)
        
        recordButton.isEnabled = true
        recordButton.setTitle("Start Recording", for: [])
    }
    
    @IBAction func recordButtonTapped() {
        if engine.isRunning {
            engine.stop()
            recordButton.setTitle("Stopping", for: .disabled)
        } else {
            try! startRecording()
            recordButton.setTitle("Stop recording", for: [])
        }
    }
    
}
