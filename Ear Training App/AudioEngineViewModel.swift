//
//  AudioEngineViewModel.swift
//  Ear Training App
//
//  Created by Jacob Yoo on 3/14/24.
//

import AVFAudio

class AudioEngineViewModel : ObservableObject {
    @Published private var model = AudioEngineModel()
    
    var allEQBands : [EQBand] {
        AudioEngineModel.allEQBands
    }
    
    var target : EQBand {
        model.target
    }
    
    var userBypass : EQBand {
        model.userBypass
    }
    
    var userEQ : EQBand {
        model.userEQ
    }
    
    var pickerNumber = 1 {
        didSet {
            updateYourEQ(eqband: allEQBands[pickerNumber])
        }
    }
    
    var disableChoice : Bool {
        model.disableChoice
    }
    
    // MARK: - Intents
    
    func playOrPause() {
        model.playOrPause()
    }
    
    func changeEQ(eqband : EQBand) {
        model.updateEQBand(eqband: eqband)
    }
    
    func updateYourEQ(eqband : EQBand) {
        model.updateYourEQ(eqband: eqband)
    }
    
    func toggleBypass() {
        model.toggleBypass()
    }
    
    func toggleTargetEQ() {
        model.toggleTargetEQ()
    }
    
    func toggleUserEQ() {
        model.toggleUserEQ()
    }
    
    func generateQuestion() {
        model.generateTarget()
    }
    
    func checkEQ() -> Bool {
        model.checkEQ()
    }
}
