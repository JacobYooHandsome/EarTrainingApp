//
//  AudioEngineViewModel.swift
//  Ear Training App
//
//  Created by Jacob Yoo on 3/14/24.
//

import AVFAudio

class AudioEngineViewModel : ObservableObject {
    @Published private var model = AudioEngineModel()
    
    // All copied variables from model
    var allEQBands : [EQBand] { AudioEngineModel.allEQBands }
    var target : EQBand { model.target }
    var userEQ : EQBand { model.userEQ }
    var disableChoice : Bool { model.disableChoice }
    var revealAnswer : Bool { model.revealAnswer }
    var correct : Bool? { model.correct }
    var userEQBandOn : Bool { model.userEQBandOn }
    var targetEQBandOn : Bool { model.targetEQBandOn }
    var bypassOn : Bool { model.bypassOn }
    
    // ViewModel specific variables
    var pickerNumber = 1 { didSet { updateYourEQ(eqband: allEQBands[pickerNumber]) } }
    
    // MARK: - Intents
    
    func playOrPause() { model.playOrPause() }
    
    func changeEQ(eqband : EQBand) { model.updateEQBand(eqband: eqband) }
    
    func updateYourEQ(eqband : EQBand) { model.updateYourEQ(eqband: eqband) }
    
    func toggleBypass() { model.toggleBypass() }
    
    func toggleTargetEQ() { model.toggleTargetEQ() }
    
    func toggleUserEQ() { model.toggleUserEQ() }
    
    func generateQuestion() { model.generateTarget() }
    
    func checkEQ() { model.checkEQ() }
}
