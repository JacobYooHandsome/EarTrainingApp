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
    var frequencies : [Float] { EqualizerModel.frequencies }
    var target : EQBand { equalizerModel.target }
    var userEQ : EQBand { equalizerModel.userEQ }
    var disableChoice : Bool { equalizerModel.disableChoice }
    var revealAnswer : Bool { equalizerModel.revealAnswer }
    var correct : Bool? { equalizerModel.correct }
    var userEQBandOn : Bool { equalizerModel.userEQBandOn }
    var targetEQBandOn : Bool { equalizerModel.targetEQBandOn }
    
    // ViewModel specific variables
    var frequencyPickerNumber = 1 { didSet { equalizerModel.updateUserEQFrequency(index: frequencyPickerNumber) } }
    
    // MARK: - Intents
    
    func playOrPause() { audioEngineModel.playOrPause() }
    
    func loadEQBand(eqband : EQBand) { EqualizerModel.loadEQBand(eqband: eqband) }
    
    func toggleBypass() { equalizerModel.toggleBypass() }
    
    func toggleTargetEQ() { equalizerModel.toggleTargetEQ() }
    
    func toggleUserEQ() { equalizerModel.toggleUserEQ() }
    
    func generateQuestion() { equalizerModel.generateTarget() }
    
    func checkEQ() { equalizerModel.checkEQ() }
}
