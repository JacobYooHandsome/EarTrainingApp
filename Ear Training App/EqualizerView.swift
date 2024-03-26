//
//  ContentView.swift
//  Ear Training App
//
//  Created by Jacob Yoo on 3/11/24.
//

import SwiftUI

struct EqualizerView: View {
    @ObservedObject var viewModel: EqualizerViewModel
    
    var body: some View {
        NavigationStack{
            VStack {
                
                if let correct = viewModel.correct {
                    if correct {
                        Text("CORRECT!!!")
                    } else {
                        Text("WRONGG!!! review your answer...")
                    }
                }
                
                Text("Frequency: " + String(Int(viewModel.frequencies[Int(viewModel.frequencyPickerNumber)])))
                Slider(value: $viewModel.frequencyPickerNumber, in: 0...Double(viewModel.frequencies.count - 1), step: 1)
                    .disabled(viewModel.disableChoice)
                
                Text("Gain: " + String(Int(viewModel.gainValues[Int(viewModel.gainPickerNumber)])))
                Slider(value: $viewModel.gainPickerNumber, in: 0...Double(viewModel.gainValues.count - 1), step: 1)
                    .disabled(viewModel.disableChoice)
                
                Text("Bandwidth: " + String(viewModel.bandwidths[Int(viewModel.bandwidthPickerNumber)]))
                Slider(value: $viewModel.bandwidthPickerNumber, in: 0...Double(viewModel.bandwidths.count - 1), step: 1)
                    .disabled(viewModel.disableChoice)
                
                Button("PLAYorPAUSE") {
                    viewModel.playOrPause()
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
                
                
                if viewModel.revealAnswer {
                    Text("TARGET: \(viewModel.target.frequency)")
                }
                HStack {
                    Button("TARGET EQ") {
                        viewModel.toggleTargetEQ()
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(viewModel.targetEQBandOn ? .red : .blue)
                    .cornerRadius(8)
                    Spacer()
                    Button("BYPASS") {
                        viewModel.toggleBypass()
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(8)
                    Spacer()
                    Button("YOUR EQ") {
                        viewModel.toggleUserEQ()
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(viewModel.userEQBandOn ? .red : .blue)
                    .cornerRadius(8)
                    
                }
                if let correct = viewModel.correct {
                    Button("SUBMIT") {
                        viewModel.checkEQ()
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(correct ? Color.green : Color.red)
                    .cornerRadius(8)
                } else {
                    Button("SUBMIT") {
                        viewModel.checkEQ()
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(8)
                }
                Button("NEXT QUESTION") {
                    viewModel.generateQuestion()
                    viewModel.toggleBypass()
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
            }
            .padding()
        }
    }
}

#Preview {
    EqualizerView(viewModel: EqualizerViewModel())
}
