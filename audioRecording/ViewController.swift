//
//  ViewController.swift
//  audioRecording
//
//  Created by Emre Erol on 25.02.2019.
//  Copyright © 2019 Codework. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileMgr = FileManager.default
        let dirPaths = fileMgr.urls(for: .documentDirectory, in: .userDomainMask)
        let soundFileURL = dirPaths[0].appendingPathComponent("ses.caf")
        let recordSettings = [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
                              AVEncoderBitRateKey: 16,
                              AVNumberOfChannelsKey: 2,
                              AVSampleRateKey: 44100.0] as
                                [String:Any]
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        }catch let error as NSError {
            print("Audio Session Error : \(error.localizedDescription)")
        }
        
        do{
            try audioRecorder = AVAudioRecorder(url: soundFileURL, settings: recordSettings as [String:AnyObject])
            audioRecorder?.prepareToRecord()
        }catch{
            print("Audio Session Error : \(error.localizedDescription)")
        }
        
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        if audioRecorder?.isRecording == false {
            audioRecorder?.record()
        }
    }
    
    @IBAction func stopAudio(_ sender: Any) {
        if audioRecorder?.isRecording == true {
            audioRecorder?.stop()
        }else{
            audioPlayer?.stop()
        }
    }
    
    @IBAction func playAudio(_ sender: Any) {
        if audioRecorder?.isRecording == false{
            do{
                try audioPlayer = AVAudioPlayer(contentsOf: (audioRecorder?.url)!)
                audioPlayer!.delegate = self
                audioPlayer!.prepareToPlay()
                audioPlayer!.play()
            }catch let error as NSError{
                print("audioPlayer error : \(error.localizedDescription)")
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Kayıttan Yürütme İşlemi Durdu")
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Kayıttan yürütme hatası")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Kayıt işlemi sonlandırıldı")
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Kayıt işlemi hatası")
    }
    

}

