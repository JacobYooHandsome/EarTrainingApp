//
//  ContentView.swift
//  Ear Training App
//
//  Created by Jacob Yoo on 3/11/24.
//

import SwiftUI

struct AudioEngineView: View {
    @ObservedObject var viewModel: AudioEngineViewModel
    @State private var clickedButtonIndex = 0
    @State private var revealAnswer = false
    @State private var color = Color.blue
    
    var body: some View {
        NavigationStack{
            VStack {
                if color == Color.green {
                    Text("CORRECT!!!")
                } else if color == Color.red {
                    Text("WRONGG!!! review your answer...")
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
                
                if revealAnswer {
                    Text("TARGET: \(viewModel.target.frequency)")
                }
                HStack {
                    SelectButton(title: "TARGET EQ", index: 1, selectedButtonIndex: $clickedButtonIndex) {
                        viewModel.toggleTargetEQ()
                    }
                    Spacer()
                    SelectButton(title: "BYPASS", index: 2, selectedButtonIndex: $clickedButtonIndex) {
                        viewModel.toggleBypass()
                    }
                    Spacer()
                    SelectButton(title: "YOUR EQ", index: 3, selectedButtonIndex: $clickedButtonIndex) {
                        viewModel.toggleUserEQ()
                    }
                }
                
                Button("SUBMIT") {
                    revealAnswer = true
                    if viewModel.checkEQ() {
                        color = .green
                    } else {
                        color = .red
                    }
                }
                .padding()
                .foregroundColor(.white)
                .background(color)
                .cornerRadius(8)
                
                Button("NEXT QUESTION") {
                    viewModel.generateQuestion()
                    viewModel.updateYourEQ(eqband: viewModel.userBypass)
                    clickedButtonIndex = 0
                    revealAnswer = false
                    color = .blue
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

struct SelectButton: View {
    var title: String
    var index: Int
    @Binding var selectedButtonIndex: Int
    var action: () -> Void

    var body: some View {
        Button(action: {
            self.selectedButtonIndex = index
            self.action()
        }) {
            Text(title)
                .padding()
                .foregroundColor(.white)
                .background(selectedButtonIndex == index ? Color.red : Color.blue)
                .cornerRadius(8)
        }
        .padding()
    }
}

#Preview {
    AudioEngineView(viewModel: AudioEngineViewModel())
}
