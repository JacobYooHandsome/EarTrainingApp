//
//  AudioEngineViewModel.swift
//  Ear Training App
//
//  Created by Jacob Yoo on 3/14/24.
//

import Foundation

class AudioEngineViewModel : ObservableObject {
    @Published private var model = AudioEngineModel()
    
    // MARK: - Intents
    
    func playOrPause() {
        model.playOrPause()
    }
    
    func setup() {
        model.setupAudio()
    }
}
