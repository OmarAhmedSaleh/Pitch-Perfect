//
//  RecordingSoundsViewController.swift
//  Pitch Perfect
//
//

import UIKit
import AVFoundation

class RecordingSoundsViewController: UIViewController ,AVAudioRecorderDelegate{

    @IBOutlet weak var Stop_bnt: UIButton!
    @IBOutlet weak var Recording_bnt: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    // MARK: Properties
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Stop_bnt.isEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func RecordAudio(_ sender: Any) {
        recordingLabel.text = "Recording in Progress"
        Stop_bnt.isEnabled = true
        Recording_bnt.isEnabled = false
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    @IBAction func StopRecording(_ sender: Any) {
        Stop_bnt.isEnabled = false
        Recording_bnt.isEnabled = true
        recordingLabel.text = "Tap to record"
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        // Send Url
        if flag{
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else{
        print("recording was not successful")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
        let playSoundsVC = segue.destination as! PlayBack
        let recordedAudioURL = sender as! URL
        playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    

}

