//
//  ContentView.swift
//  Ear Training App
//
//  Created by Jacob Yoo on 3/11/24.
//

import SwiftUI

struct AudioEngineView: View {
    @ObservedObject var viewModel: AudioEngineViewModel
    
    var body: some View {
        VStack {
            Button("PLAYorPAUSE") {
                viewModel.setup()
                viewModel.playOrPause()
            }
        }
        .padding()
    }
}

#Preview {
    AudioEngineView(viewModel: AudioEngineViewModel())
}
