//
//  ViewController8.swift
//  AudioEngineSimpleApp
//
//  Created by Imanou Petit on 08/02/2017.
//  Copyright © 2017 Imanou Petit. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController8: UIViewController {
    
    let engine = AVAudioEngine()
    let player = AVAudioPlayerNode()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "VC8"
        
        engine.attach(player)
        engine.connect(player, to: engine.mainMixerNode, format: engine.mainMixerNode.outputFormat(forBus: 0))
        
        do {
            try engine.start()
        } catch {
            print("Error: \(error)")
        }
        
        //Check if a file already exists. If so continue to record at the end of it
        var audioBuffer: AVAudioPCMBuffer!
        var audioFrameCount: AVAudioFrameCount!

        guard let inputUrl = Bundle.main.url(forResource: "drumLoop", withExtension: "caf") else { return }
        let existingAudioFile: AVAudioFile
        do {
            existingAudioFile = try AVAudioFile(forReading: inputUrl)
            audioFrameCount = AVAudioFrameCount(existingAudioFile.length)
            if (audioFrameCount > 0) {
                audioBuffer = AVAudioPCMBuffer(pcmFormat: existingAudioFile.processingFormat, frameCapacity: audioFrameCount)
                try existingAudioFile.read(into: audioBuffer)
            }
        } catch {
            print("Error reading buffer from file: \(error)")
            return
        }

        //Create a new file. This will replace the old file
        guard let outputUrl = urlFor(filename: "test.caf") else { return }

        let audioFile: AVAudioFile
        do {
            //audioFile = try AVAudioFile(forWriting: outputUrl, settings: engine.mainMixerNode.outputFormat(forBus: 0).settings)
            audioFile = try AVAudioFile(forWriting: outputUrl, settings: existingAudioFile.fileFormat.settings)
        } catch {
            print("Error creating AVAudioFile: \(error)")
            return
        }
        
        //Read the audio buffer from the old file into the new file
        if (audioBuffer != nil) {
            do {
                try audioFile.write(from: audioBuffer)
                audioFile.framePosition = audioFile.length
            } catch {
                print("Error reading buffer into file: \(error)")
            }
        }
        
        print(applicationSupportDirectory())
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
