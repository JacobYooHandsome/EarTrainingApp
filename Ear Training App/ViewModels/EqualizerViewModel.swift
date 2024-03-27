//
//  AudioEngineViewModel.swift
//  Ear Training App
//
//  Created by Jacob Yoo on 3/14/24.
//

import AVFAudio

class EqualizerViewModel : ObservableObject {
    @Published private var audioEngineModel = AudioEngineModel()
    @Published private var equalizerModel = EqualizerModel()
    
    // All copied variables from model
    var frequencies: [Float] { EqualizerModel.frequencies }
    var gainValues: [Float] { EqualizerModel.gainValues }
    var bandwidths: [Float] { EqualizerModel.bandwidths }
    var targetEQ: EQBand { equalizerModel.targetEQ }
    var userEQ: EQBand { equalizerModel.userEQ }
    var disableChoice: Bool { equalizerModel.disableChoice }
    var revealAnswer: Bool { equalizerModel.revealAnswer }
    var correct: Bool? { equalizerModel.correct }
    
    
    // The pickers that control the model
    var loadedEQPicker: Int = 0 {
        didSet{ equalizerModel.toggleEQ(index: loadedEQPicker) }
    }
    var frequencyPicker: Double = 0 {
        didSet{ equalizerModel.updateUserEQFrequency(index: Int(frequencyPicker)) }
    }
    var gainPicker: Double = 6 {
        didSet{ equalizerModel.updateUserEQGain(index: Int(gainPicker)) }
    }
    var bandwidthPicker: Double = 0 {
        didSet{ equalizerModel.updateUserEQBandwidth(index: Int(bandwidthPicker)) }
    }
    
    // Pickers for the settings
    var frequencyResolutions: [Float] { equalizerModel.frequencyResolutions }
    
    var frequencyResolutionPicker: Float = 1 {
        didSet{ equalizerModel.changeGameFrequencyResolution(octave: frequencyResolutionPicker) }
    }
    var bandwidthRangePicker: Int = 0
    var gainRangePicker: Int = 0
    var numOfBandsPicker: Int = 0
    var frequencyRangePicker: Int = 0
    
    // MARK: - Intents
    
    func playOrPause() { audioEngineModel.playOrPause() }
    
    func loadEQBand(eqband: EQBand) { equalizerModel.loadEQBand(eqband: eqband) }
    
    func toggleBypass() { equalizerModel.toggleBypass() }
    
    func toggleTargetEQ() { equalizerModel.toggleTargetEQ() }
    
    func toggleUserEQ() { equalizerModel.toggleUserEQ() }
    
    func generateQuestion() { equalizerModel.generateTarget() }
    
    func checkEQ() { equalizerModel.checkEQ() }
    
    func togglePlayStartGame() { equalizerModel.togglePlayStartGame() }
}
