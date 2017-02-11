
import UIKit
import AVFoundation

class RecordController: UIViewController {
    
    @IBOutlet weak var recordButton: UIButton!
    let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("test.caf")
    var engine = AVAudioEngine()
    
    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordButton.setTitle("Record", for: .normal)
        
        let file: AVAudioFile
        do {
            file = try AVAudioFile(forWriting: url, settings: engine.inputNode!.outputFormat(forBus: 0).settings)
        } catch {
            print("Error: \(error)")
            return
        }
        
        engine.inputNode?.installTap(onBus: 0, bufferSize: 1024, format: engine.inputNode!.outputFormat(forBus: 0)) { (buffer, time) -> Void in
            do {
                try file.write(from: buffer)
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    @IBAction func toggleAction(_ sender: AnyObject) {
        engine.isRunning ? stopRecording() : startRecording()
    }
    
    func startRecording() {
        do {
            // Start engine
            try engine.start()
            
            // Toggle button title
            recordButton.setTitle("Stop", for: .normal)
        } catch {
            print("Error: \(error)")
        }
    }
    
    func stopRecording() {
        // Remove tap and stop engine
        engine.stop()
        
        // Toggle button title
        recordButton.setTitle("Record", for: .normal)
        
        // Present PlayController
        guard let playerController = storyboard?.instantiateViewController(withIdentifier: "PlayerController") as? PlayController else { return }
        playerController.sourceUrl = url
        navigationController?.pushViewController(playerController, animated: true)
    }
    
}
