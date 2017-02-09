
import UIKit
import AVFoundation

class ViewController4: UIViewController {
    
    var engine = AVAudioEngine()
    var file: AVAudioFile?
    var player = AVAudioPlayerNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)

            let hwSampleRate = 44100.0
            try AVAudioSession.sharedInstance().setPreferredSampleRate(hwSampleRate)

            let ioBufferDuration: TimeInterval = 0.0029
            try AVAudioSession.sharedInstance().setPreferredIOBufferDuration(ioBufferDuration)
        } catch {
            print(error)
        }
        
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
        engine.inputNode?.installTap(onBus: 0, bufferSize: 1024, format: engine.mainMixerNode.outputFormat(forBus: 0)) { [unowned engine] (buffer, time) -> Void in
            do {
                let mainMixer = engine.mainMixerNode
                let mixerOutputFile = try AVAudioFile(forWriting: url, settings: mainMixer.outputFormat(forBus: 0).settings)
                try mixerOutputFile.write(from: buffer)
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    @IBAction func stop(sender: AnyObject) {
        engine.inputNode?.removeTap(onBus: 0)
        print(applicationSupportDirectory())
        
        guard let playerController = storyboard?.instantiateViewController(withIdentifier: "PlayerController") as? PlayerController else { return }
        present(playerController, animated: true, completion: nil)
    }
    
    func urlFor(filename: String) -> URL? {
        if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first {
            let path = dir.appending(filename)
            return URL(fileURLWithPath: path)
        }
        return nil
    }
    
    func applicationSupportDirectory() -> URL {
        let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        let applicationSupportUrl = urls[urls.endIndex - 1]
        return applicationSupportUrl
    }
    
}
