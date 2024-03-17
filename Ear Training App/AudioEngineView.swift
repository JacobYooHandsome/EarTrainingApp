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
        NavigationStack{
            VStack {
                if let correct = viewModel.correct {
                    if correct {
                        Text("CORRECT!!!")
                    } else {
                        Text("WRONGG!!! review your answer...")
                    }
                }
                Button("PLAYorPAUSE") {
                    viewModel.playOrPause()
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
                
                Picker("EQ", selection: $viewModel.pickerNumber) {
                    ForEach(0..<viewModel.allEQBands.count, id: \.self) {

                        Text(String(Int(viewModel.allEQBands[$0].frequency)))
                  }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.bottom, 20)
                .lineLimit(nil)
                .frame(width: 400)
                .disabled(viewModel.disableChoice)
                
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
    AudioEngineView(viewModel: AudioEngineViewModel())
}
