//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Matthias on 13/03/15.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var startRecordingButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var tapToRecordLabel: UILabel!
    @IBOutlet weak var recordingInProgressLabel: UILabel!

    @IBAction func startRecording(sender: UIButton) {
        // Disable "start recording" button.
        startRecordingButton.enabled = false

        // Enable "stop recording" button.
        stopRecordingButton.enabled = true
        stopRecordingButton.hidden = false

        // Hide "tap to record" label.
        tapToRecordLabel.hidden = true

        // Display "recording in progress" label.
        recordingInProgressLabel.hidden = false

        // Set the audio session category.
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)

        // Start recording.
        audioRecorder = AVAudioRecorder(URL: generateAudioRecordingFileUrl(), settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.record()
    }

    @IBAction func stopRecording(sender: UIButton) {
        // Disable "stop recording" button.
        stopRecordingButton.enabled = false

        // Stop recording.
        audioRecorder.stop()

        // Deactive recording session.
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "stopRecordingSegue":
                if let viewController = segue.destinationViewController as? PlaybackViewController {
                    viewController.recordedAudio = sender as? RecordedAudio
                }
            default:
                break
            }
        }
    }

    func generateAudioRecordingFileUrl() -> NSURL {
        // Get location of users document directory.
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String;

        // Create date formatter.
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"

        // Generate unique filename.
        let fileName = formatter.stringFromDate(NSDate()) + ".wav"

        // Return URL of filename in document directory.
        return NSURL.fileURLWithPathComponents([documentDirectory, fileName])!
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        // Hide "stop recording" button.
        stopRecordingButton.hidden = true

        // Hide "recording in progress" label.
        recordingInProgressLabel.hidden = true

        // Display "tap to record" label.
        tapToRecordLabel.hidden = false

        // Enable "start recording" button.
        startRecordingButton.enabled = true

        // Perform segue to PlaybackViewController.
        if (flag) {
            let recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent!, url: recorder.url)
            performSegueWithIdentifier("stopRecordingSegue", sender: recordedAudio)
        }
    }
}