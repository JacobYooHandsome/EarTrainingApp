//
//  ContentView.swift
//  Ear Training App
//
//  Created by Jacob Yoo on 3/11/24.
//

import SwiftUI

struct EqualizerView: View {
    @ObservedObject var viewModel: EqualizerViewModel
    @State var menuOpened = false
    
    var body: some View {
        ZStack {
            NavigationStack{
                VStack {
                    Spacer()
                    if let correct = viewModel.correct {
                        if correct {
                            Text("CORRECT!!!").bold()
                        } else {
                            Text("WRONGG!!! review your answer...").bold()
                        }
                    }
                    
                    HStack {
                        if let correct = viewModel.correct {
                            Button("NEXT QUESTION") {
                                viewModel.generateQuestion()
                                viewModel.toggleBypass()
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
                    }
                    
                    Text("TARGET DEBUG: \(Int(viewModel.targetEQ.frequency))hz")
                    Text("TARGET DEBUG: \(Int(viewModel.targetEQ.gain))db")
                    Text("TARGET DEBUG: \((viewModel.targetEQ.bandwidth))Q")
                    
                    Text("USER DEBUG: \(Int(viewModel.userEQ.frequency))hz")
                    Text("USER DEBUG: \(Int(viewModel.userEQ.gain))db")
                    Text("USER DEBUG: \((viewModel.userEQ.bandwidth))Q")
                    
                    if viewModel.revealAnswer {
                        Text("TARGET: \(Int(viewModel.targetEQ.frequency))hz")
                        Text("USER: \(Int(viewModel.userEQ.frequency))hz")
                    }
                    
                    Spacer()
                    
                    Text("Frequency: " + String(Int(viewModel.frequencies[Int(viewModel.frequencySlider)])))
                    Slider(value: $viewModel.frequencySlider, in: 0...Double(viewModel.frequencies.count - 1), step: 1)
                        .disabled(viewModel.disableChoice)
                    
                    Text("Gain: " + String(Int(viewModel.gainValues[Int(viewModel.gainSlider)])))
                    Slider(value: $viewModel.gainSlider, in: 0...Double(viewModel.gainValues.count - 1), step: 1)
                        .disabled(viewModel.disableChoice)
                    
                    Text("Bandwidth: " + String(viewModel.bandwidths[Int(viewModel.bandwidthSlider)]))
                    Slider(value: $viewModel.bandwidthSlider, in: 0...Double(viewModel.bandwidths.count - 1), step: 1)
                        .disabled(viewModel.disableChoice)
                    
                    Picker("Select an EQ:", selection: $viewModel.loadedEQPicker) {
                        Text("TARGET EQ").tag(0)
                        Text("BYPASS").tag(1)
                        Text("USER EQ").tag(2)
                    }
                    .labelsHidden()
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Spacer()
                    
                    Button(action: { viewModel.playOrPause(); viewModel.togglePlayStartGame()}, label: {
                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                    })
                    .padding()
                    .foregroundColor(.blue)
                    .cornerRadius(8)
                }
                .padding()
                .navigationTitle("Equalizer")
                .toolbar {
                    Button(action: {
                        menuOpened.toggle()
                    }, label: {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                    })
                    
                }
            }
            SideBar(viewModel: viewModel, width: UIScreen.main.bounds.width/2, menuOpened: menuOpened, toggleMenu: toggleMenu)
        }
        .ignoresSafeArea(.all)
    }
    
    func toggleMenu() {
        menuOpened.toggle()
    }
}

#Preview {
    EqualizerView(viewModel: EqualizerViewModel())
}
