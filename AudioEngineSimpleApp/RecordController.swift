
import UIKit
import AVFoundation

class RecordController: UIViewController {
    
    @IBOutlet weak var recordButton: UIButton!
    let url = URL(fileURLWithPath: NSTemporaryDirectory().appending("test.caf"))
    var engine = AVAudioEngine()
    var file: AVAudioFile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordButton.setTitle("Record", for: .normal)
        
        do {
            file = try AVAudioFile(forWriting: url, settings: engine.inputNode!.outputFormat(forBus: 0).settings)
        } catch {
            print("Error: \(error)")
        }
        
        engine.inputNode?.installTap(onBus: 0, bufferSize: 1024, format: engine.inputNode!.outputFormat(forBus: 0)) { (buffer, time) -> Void in
            do {
                try self.file?.write(from: buffer)
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    @IBAction func record(_ sender: AnyObject) {
        if engine.isRunning {
            // Toggle button title
            recordButton.setTitle("Record", for: .normal)
            
            // Stop engine and push PlayController
            engine.inputNode?.removeTap(onBus: 0)
            guard let playerController = storyboard?.instantiateViewController(withIdentifier: "PlayerController") as? PlayController else { return }
            navigationController?.pushViewController(playerController, animated: true)
        } else {
            // Toggle button title
            recordButton.setTitle("Stop", for: .normal)
            
            // Start engine
            do {
                try engine.start()
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
}
