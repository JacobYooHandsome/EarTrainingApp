//
//  EqualizerModel.swift
//  Ear Training App
//
//  Created by Jacob Yoo on 3/17/24.
//

import Foundation
import AVFAudio

struct EqualizerModel {
    static private let equalizer = AVAudioUnitEQ(numberOfBands: 1)
    
    private (set) var disableChoice = true
    private (set) var revealAnswer = false
    private (set) var correct : Bool?
    
    // All the EQBand variables
    static private (set) var gainValues : [Float] = [-9, -6, -3, 0, 3, 6, 9]
    static private (set) var bandwidths : [Float] = [1.5, 3.0]
    static private (set) var frequencies : [Float] = [63, 125, 250, 500, 1000, 2000, 4000, 8000, 16000]
    //static private var frequencies2 : [Float] = [63, 80, 100, 125, 160, 200, 250, 315, 400, 500, 630, 800, 1000, 1250, 1600, 2000, 2500, 3150, 4000, 5000, 6300, 8000, 10000, 12500, 16000]
    
    private (set) var userEQ : EQBand = .init(bandwidth: 1.5, bypass: false, frequency: 63, gain: 9) {
        didSet {
            loadEQBand(eqband: userEQ)
        }
    }
    private (set) var target : EQBand
    private (set) var userEQBandOn = false
    private (set) var targetEQBandOn = false
    
    // initalizes the targetEQ question and sets up the audio
    init() {
        target = EQBand.init(bandwidth: 1.5, bypass: false, frequency: EqualizerModel.frequencies.randomElement() ?? 1000, gain: 9)
    }
    
    func loadEQBand(eqband: EQBand) {
        EqualizerModel.equalizer.bands[0].bandwidth = eqband.bandwidth
        EqualizerModel.equalizer.bands[0].bypass = eqband.bypass
        EqualizerModel.equalizer.bands[0].frequency = eqband.frequency
        EqualizerModel.equalizer.bands[0].gain = eqband.gain
    }
    
    mutating func updateUserEQFrequency(index: Int) {
        userEQ.frequency = EqualizerModel.frequencies[index]
    }
    
    mutating func updateUserEQGain(index: Int) {
        userEQ.gain = EqualizerModel.gainValues[index]
    }
    
    mutating func updateUserEQBandwidth(index: Int) {
        userEQ.bandwidth = EqualizerModel.bandwidths[index]
    }
    
    mutating func checkEQ() {
        revealAnswer = true
        correct = (userEQ.frequency == target.frequency)
    }
    
    mutating func generateTarget() {
        guard let random = EqualizerModel.frequencies.randomElement() else {
            return
        }
        revealAnswer = false
        target.frequency = random
        correct = nil
    }
    
    mutating func toggleBypass() {
        loadEQBand(eqband: .init(bandwidth: 1.5, bypass: true, frequency: 63, gain: 0))
        disableChoice = true
        userEQBandOn = false
        targetEQBandOn = false
    }
    
    mutating func toggleTargetEQ() {
        loadEQBand(eqband: target)
        disableChoice = true
        userEQBandOn = false
        targetEQBandOn = true
    }
    
    mutating func toggleUserEQ() {
        loadEQBand(eqband: userEQ)
        disableChoice = false
        userEQBandOn = true
        targetEQBandOn = false
    }
    
    static func returnEqualizer() -> AVAudioUnit {
        return equalizer
    }
}
