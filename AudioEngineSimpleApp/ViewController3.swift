
import UIKit
import AVFoundation

class ViewController3: UIViewController {
    
    var engine = AVAudioEngine()
    var file: AVAudioFile?
    var player = AVAudioPlayerNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(AVAudioSessionCategoryRecord)
        try! audioSession.setMode(AVAudioSessionModeMeasurement)
        try! audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        guard let url = urlFor(filename: "test.caf") else { return }
        
        do {
             file = try AVAudioFile(forWriting: url, settings: engine.inputNode!.inputFormat(forBus: 0).settings, commonFormat: engine.inputNode!.inputFormat(forBus: 0).commonFormat, interleaved: false)
        } catch {
            print("Error: \(error)")
        }
        
        engine.attach(player)
        engine.connect(player, to: engine.mainMixerNode, format: engine.mainMixerNode.outputFormat(forBus: 0))
        
        engine.prepare()
        do {
            try engine.start()
        } catch {
            print("Error: \(error)")
        }
    }
    
    @IBAction func record(_ sender: AnyObject) {
        engine.inputNode?.installTap(onBus: 0, bufferSize: 1024, format: engine.mainMixerNode.outputFormat(forBus: 0)) { (buffer, time) -> Void in
            do {
                try self.file?.write(from: buffer)
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    @IBAction func stop(_ sender: AnyObject) {
        engine.inputNode?.removeTap(onBus: 0)
        //print(applicationSupportDirectory())
        
        guard let playerController = storyboard?.instantiateViewController(withIdentifier: "PlayerController") as? PlayerController else { return }
        navigationController?.pushViewController(playerController, animated: true)
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

class ViewController11: UIViewController {
    
    var engine = AVAudioEngine()
    var file: AVAudioFile?
    var player = AVAudioPlayerNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
//        try! audioSession.setMode(AVAudioSessionModeMeasurement)
//        try! audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        engine.attach(player)
        engine.connect(player, to: engine.mainMixerNode, format: engine.inputNode!.outputFormat(forBus: 0))
    }
    
    @IBAction func record(_ sender: AnyObject) {
        guard let url = urlFor(filename: "test.caf") else { return }
        //let url = URL(string: NSTemporaryDirectory().appending("test.caf"))!
        do {
            file = try AVAudioFile(forWriting: url, settings: engine.inputNode!.outputFormat(forBus: 0).settings)
            //file = try AVAudioFile(forWriting: url, settings: engine.inputNode!.inputFormat(forBus: 0).settings, commonFormat: engine.inputNode!.inputFormat(forBus: 0).commonFormat, interleaved: false)
        } catch {
            print("Error: \(error)")
        }
        
        engine.inputNode?.installTap(onBus: 0, bufferSize: 1024, format: engine.inputNode!.outputFormat(forBus: 0)) { (buffer, time) -> Void in
            do {
                try self.file?.write(from: buffer)
                print(buffer)
            } catch {
                print("Error: \(error)")
            }
        }
        
        //engine.prepare()
        do {
            try engine.start()
        } catch {
            print("Error: \(error)")
        }
    }
    
    @IBAction func stop(_ sender: AnyObject) {
        engine.inputNode?.removeTap(onBus: 0)
        //engine.mainMixerNode.removeTap(onBus: 0)
        //print(applicationSupportDirectory())
        //print(URL(string: NSTemporaryDirectory().appending("test.caf"))!)
        
        guard let playerController = storyboard?.instantiateViewController(withIdentifier: "PlayerController") as? PlayerController else { return }
        navigationController?.pushViewController(playerController, animated: true)
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
