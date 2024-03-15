//
//  AudioEngine.swift
//  Ear Training App
//
//  Created by Jacob Yoo on 3/14/24.
//

import Foundation
import AVFAudio

struct AudioEngineModel {
    private let engine = AVAudioEngine()
    private let player = AVAudioPlayerNode()
    private let equalizer = AVAudioUnitEQ(numberOfBands: 1)
    
    static private var userGain : Float = 9

    private (set) var userBypass : EQBand = .init(bandwidth: 1.5, bypass: true, frequency: 63, gain: 0)
    private (set) var userEQ : EQBand = .init(bandwidth: 1.5, bypass: true, frequency: 63, gain: 0)
    private (set) var target : EQBand
    
    static private (set) var allEQBands: [EQBand] = [
        .init(bandwidth: 1.5, bypass: false, frequency: 63, gain: userGain),
        .init(bandwidth: 1.5, bypass: false, frequency: 125, gain: userGain),
        .init(bandwidth: 1.5, bypass: false, frequency: 250, gain: userGain),
        .init(bandwidth: 1.5, bypass: false, frequency: 500, gain: userGain),
        .init(bandwidth: 1.5, bypass: false, frequency: 1000, gain: userGain),
        .init(bandwidth: 1.5, bypass: false, frequency: 2000, gain: userGain),
        .init(bandwidth: 1.5, bypass: false, frequency: 4000, gain: userGain),
        .init(bandwidth: 1.5, bypass: false, frequency: 8000, gain: userGain),
        .init(bandwidth: 1.5, bypass: false, frequency: 16000, gain: userGain),
    ]
    
    private var isPlayerReady = false
    var audioFile : AVAudioFile?
    var needsFileScheduled = true
    var isPlaying = false
    var disableChoice = true
    
    init() {
        target = AudioEngineModel.instantiateTarget()
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
    
    func updateEQBand(eqband: EQBand) {
        equalizer.bands[0].bandwidth = eqband.bandwidth
        equalizer.bands[0].bypass = eqband.bypass
        equalizer.bands[0].frequency = eqband.frequency
        equalizer.bands[0].gain = eqband.gain
    }
    
    func checkEQ() -> Bool {
        return userEQ.frequency == target.frequency
    }
    
    mutating func updateYourEQ(eqband : EQBand) {
        userEQ = eqband
        updateEQBand(eqband: eqband)
    }
    
    mutating func generateTarget() {
        guard let random = AudioEngineModel.allEQBands.randomElement() else {
            return
        }
        target = random
    }
    
    static func instantiateTarget() -> EQBand {
        guard let random = AudioEngineModel.allEQBands.randomElement() else {
            return .init(bandwidth: 1.5, bypass: true, frequency: 63, gain: 0)
        }
        return random
    }
    
    mutating func toggleBypass() {
        updateEQBand(eqband: userBypass)
        disableChoice = true
    }
    
    mutating func toggleTargetEQ() {
        updateEQBand(eqband: target)
        disableChoice = true
    }
    
    mutating func toggleUserEQ() {
        updateEQBand(eqband: userEQ)
        disableChoice = false
    }
}
