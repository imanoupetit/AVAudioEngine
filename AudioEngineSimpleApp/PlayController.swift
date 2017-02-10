
import AVFoundation
import AVKit

class PlayController: UIViewController {
    
    let url = URL(fileURLWithPath: NSTemporaryDirectory().appending("test.caf"))
    let player = AVPlayer()
    var sourceUrl: URL? {
        didSet {
            // Update player with new source audio file or nothing if sourceUrl is nil
            let playerItem: AVPlayerItem? = sourceUrl.map { AVPlayerItem(url: $0) }
            player.replaceCurrentItem(with: playerItem)
        }
    }
    
    // MARK: View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sourceUrl = url
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Configure our AVPlayer instance property
        let playerViewController = segue.destination as! AVPlayerViewController
        playerViewController.player = player
    }
    
}
