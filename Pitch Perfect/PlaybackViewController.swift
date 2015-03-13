//
//  PlaybackViewController.swift
//  Pitch Perfect
//
//  Created by Matthias on 13/03/15.
//

import UIKit
import AVFoundation

class PlaybackViewController: UIViewController {

    var recordedAudio: RecordedAudio?

    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!

    @IBAction func playAudioSlow(sender: UIButton) {
        play(rate: 0.5)
    }

    @IBAction func playAudioFast(sender: UIButton) {
        play(rate: 2.0)
    }

    @IBAction func playAudioChipmunk(sender: UIButton) {
        play(pitch: 1000.0)
    }

    @IBAction func playAudioDarthVader(sender: UIButton) {
        play(pitch: -1000.0)
    }

    @IBAction func stopAudio(sender: UIButton) {
        stop()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // If we received an audio recording, initialize playback.
        if let recordedAudio = recordedAudio {
            // Load the recorded audio.
            audioFile = AVAudioFile(forReading: recordedAudio.url, error: nil)

            // Create audio engine.
            audioEngine = AVAudioEngine()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func play(rate: Float = 1.0, pitch: Float = 0.0) {
        // Stop playback.
        stop()

        // Add audio player node to engine.
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)

        // Add pitch node to engine.
        let audioPitchNode = AVAudioUnitTimePitch()
        audioPitchNode.pitch = pitch
        audioPitchNode.rate = rate
        audioEngine.attachNode(audioPitchNode)

        // Connect nodes.
        audioEngine.connect(audioPlayerNode, to: audioPitchNode, format: nil)
        audioEngine.connect(audioPitchNode, to: audioEngine.outputNode, format: nil)

        // Start audio engine.
        audioEngine.startAndReturnError(nil)

        // Play audio file.
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioPlayerNode.play()
    }

    func stop() {
        // Stop audio engine.
        audioEngine.stop()
    }
}