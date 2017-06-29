//
//  ViewController.swift
//  AudioRecord
//
//  Created by Admin on 29.06.17.
//  Copyright © 2017 rusel95. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    @IBOutlet weak var recordOutlet: UIButton!
    @IBOutlet weak var playOutlet: UIButton!
    
    var soundRecorder : AVAudioRecorder!
    var soundPlayer : AVAudioPlayer!
    
    var fileName = "audioFile.m4a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preparePlayer()
        setupRecorder()
    }
    
    func setupRecorder() {
        let recordSettings = [AVFormatIDKey: kAudioFormatAppleLossless,
                              AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
                              AVEncoderBitRateKey: 96000,
                              AVNumberOfChannelsKey: 1,
                              AVSampleRateKey: 44100.0] as [String : Any]
        
        do {
            soundRecorder = try AVAudioRecorder(url: getFileUrl(), settings: recordSettings)
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
        } catch {
            debugPrint("Something wrong:", error)
        }
    }
    
    func getCacheDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        return paths[0]
    }
    
    func getFileUrl() -> URL {
        let path = getCacheDirectory().appending(fileName)
        
        let filePath = URL(fileURLWithPath: path)
        
        return filePath
    }

    @IBAction func recordButton(_ sender: UIButton) {
        if sender.titleLabel?.text == "record" {
            soundRecorder.record()
            sender.setTitle("stop", for: .normal)
            playOutlet.isEnabled = false
        } else {
            soundRecorder.stop()
            sender.setTitle("record", for: .normal)
            playOutlet.isEnabled = false
        }
    }
    
    @IBAction func playButton(_ sender: UIButton) {
        if sender.titleLabel?.text == "play" {
            recordOutlet.isEnabled = false
            sender.setTitle("stop", for: .normal)
            
            preparePlayer()
            soundPlayer.play()
        } else {
            soundPlayer.stop()
            sender.setTitle("play", for: .normal)
        }
    }
    
    func preparePlayer(){
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: getFileUrl())
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
        } catch {
            debugPrint("Something wrong:", error)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        playOutlet.isEnabled = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordOutlet.isEnabled = true
        playOutlet.setTitle("play", for: .normal)
    }

}

