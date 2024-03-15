//
//  Ear_Training_AppApp.swift
//  Ear Training App
//
//  Created by Jacob Yoo on 3/11/24.
//

import SwiftUI

@main
struct EarTrainingApp: App {
    @StateObject var audioEngine = AudioEngineViewModel()
    
    var body: some Scene {
        WindowGroup {
            AudioEngineView(viewModel: audioEngine)
        }
    }
}
