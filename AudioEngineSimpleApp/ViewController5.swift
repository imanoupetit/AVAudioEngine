
import UIKit
import AVFoundation

class ViewController5: UIViewController {
    
    var engine = AVAudioEngine()
    var file: AVAudioFile?
    var player = AVAudioPlayerNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        engine.attach(player)
        engine.connect(player, to: engine.mainMixerNode, format: engine.mainMixerNode.outputFormat(forBus: 0))
        
        do {
            try engine.start()
        } catch {
            print("Error: \(error)")
        }
    }
    
    @IBAction func record(sender: AnyObject) {
        guard let url = urlFor(filename: "test.caf") else { return }
        do {
            file = try AVAudioFile(forWriting: url, settings: engine.inputNode!.inputFormat(forBus: 0).settings, commonFormat: engine.inputNode!.inputFormat(forBus: 0).commonFormat, interleaved: false)
        } catch {
            print("Error: \(error)")
        }

        engine.inputNode?.installTap(onBus: 0, bufferSize: 1024, format: engine.mainMixerNode.outputFormat(forBus: 0)) { (buffer, time) -> Void in
            do {
                try self.file?.write(from: buffer)
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    @IBAction func stop(sender: AnyObject) {
        engine.inputNode?.removeTap(onBus: 0)
        // Print the url to the saved file
        let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        print(urls[urls.endIndex - 1])
        
        guard let playerController = storyboard?.instantiateViewController(withIdentifier: "PlayerController") as? PlayerController else { return }
        present(playerController, animated: true, completion: nil)
    }
    
    func urlFor(filename: String) -> URL? {
        // Get url of saved file
        if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first {
            let path = dir.appending(filename)
            return URL(fileURLWithPath: path)
        }
        return nil
    }
    
}
