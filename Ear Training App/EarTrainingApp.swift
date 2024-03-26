//
//  Ear_Training_AppApp.swift
//  Ear Training App
//
//  Created by Jacob Yoo on 3/11/24.
//

import SwiftUI

@main
struct EarTrainingApp: App {
    @StateObject var equalizerViewModel = EqualizerViewModel()
    
    var body: some Scene {
        WindowGroup {
            EqualizerView(viewModel: equalizerViewModel)
        }
    }
}
