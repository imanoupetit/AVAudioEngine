
import AVFoundation
import AVKit

class PlayerController: UIViewController {
    
    let player = AVPlayer()
    var sourceURL: URL? {
        // Update `playerViewController` with new source movie or audio file
        didSet {
            let playerItem: AVPlayerItem?
            
            if let sourceURL = sourceURL {
                playerItem = AVPlayerItem(url: sourceURL)
            } else {
                playerItem = nil
            }
            
            player.replaceCurrentItem(with: playerItem)
        }
    }
    
    // MARK: View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = urlFor(filename: "test.caf") else { return }
        //let url = URL(string: NSTemporaryDirectory().appending("test.caf"))!
        sourceURL = url
    }
    
    func urlFor(filename: String) -> URL? {
        if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first {
            let path = dir.appending(filename)
            return URL(fileURLWithPath: path)
        }
        return nil
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playerViewController" {
            // This segue fires before `viewDidLoad()` is invoked.
            let playerViewController = segue.destination as! AVPlayerViewController
            playerViewController.player = player
        }
    }
    
}
