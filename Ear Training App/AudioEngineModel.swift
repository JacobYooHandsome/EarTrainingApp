//
//  AudioEngine.swift
//  Ear Training App
//
//  Created by Jacob Yoo on 3/14/24.
//

import Foundation
import AVFAudio

struct AudioEngineModel {
    // All the audio playing and engine variables needed
    private let engine = AVAudioEngine()
    private let player = AVAudioPlayerNode()
    private var isPlayerReady = false
    private var audioFile : AVAudioFile?
    private var needsFileScheduled = true
    private var isPlaying = false
    
    // Variables related to the view
    private (set) var disableChoice = true
    private (set) var revealAnswer = false
    private (set) var correct : Bool?
    
    // initalizes the targetEQ question and sets up the audio
    init() {
        setupAudio()
    }
    
    mutating func setupAudio() {
        
      guard let fileURL = Bundle.main.url(forResource: "help", withExtension: "m4a") else {
        print("Error reading the file")
        return
      }
        
      do {
        let file = try AVAudioFile(forReading: fileURL)
        let format = file.processingFormat

        audioFile = file

        configureEngine(with: format)
      } catch {
        print("Error reading the audio file: \(error.localizedDescription)")
      }
    }
    
    mutating func configureEngine(with format: AVAudioFormat) {
        let equalizer = EqualizerModel.returnEqualizer()
        engine.attach(player)
        engine.attach(equalizer)

        engine.connect(player, to: equalizer, format: format)
        engine.connect(equalizer, to: engine.mainMixerNode, format: format)
        
        engine.prepare()
        
        do {
            try engine.start()

            scheduleAudioFile()
        
        } catch {
            print("Error starting the player: \(error.localizedDescription)")
        }
    }
    
    mutating func scheduleAudioFile() {
      // If there is an audio file and needsFileScheduled is true then continue with this function
      guard
        let file = audioFile,
        needsFileScheduled
      else {
        return
      }
      
      // Set needsFileScheduled to now be false
      needsFileScheduled = false
      
      // if the parameter is nil, plays the file at sample time 0
      // The closure is the handler the system calls after the player schedules for playback or the player stops
      player.scheduleFile(file, at: nil)
      needsFileScheduled = true
    }
    
    mutating func playOrPause() {
      // toggles the isPlaying boolean
      isPlaying.toggle()
      
      // If the player is playing,
      if player.isPlaying {
        player.pause()
      } else {
        if needsFileScheduled {
          scheduleAudioFile()
        }
        player.play()
      }
    }
}
