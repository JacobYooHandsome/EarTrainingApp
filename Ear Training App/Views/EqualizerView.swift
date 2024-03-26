//
//  ContentView.swift
//  Ear Training App
//
//  Created by Jacob Yoo on 3/11/24.
//

import SwiftUI

struct EqualizerSideBarSettings: View {
    var body: some View {
        ZStack {
            Color(.gray)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Frequency Resolution")
                Text("Bandwidth")
                Text("Frequency Range")
                Text("Gain Range")
                Text("Number of Bands")
                Spacer()
            }
            .safeAreaPadding(.top, 50)
            .foregroundColor(.white)
        }
    }
}

struct SideBar: View {
    let width: CGFloat
    let menuOpened: Bool
    let toggleMenu: () -> Void
    
    var body: some View {
        ZStack {
            GeometryReader { _ in
                HStack {
                    EqualizerSideBarSettings()
                        .frame(width: width)
                        .offset(x: menuOpened ? 0 : -width)
                }
            }
            .background(Color.gray.opacity(0.5))
            .opacity(self.menuOpened ? 1 : 0)
            .animation(.easeIn.delay(0.25), value: self.menuOpened)
            .onTapGesture {
                self.toggleMenu()
            }
            
            
        }
    }
}

struct EqualizerView: View {
    @ObservedObject var viewModel: EqualizerViewModel
    @State var menuOpened = false
    
    var body: some View {
        ZStack {
            NavigationStack{
                VStack {
                    
                    if let correct = viewModel.correct {
                        if correct {
                            Text("CORRECT!!!")
                        } else {
                            Text("WRONGG!!! review your answer...")
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
                    
                    Text("Frequency: " + String(Int(viewModel.frequencies[Int(viewModel.frequencyPickerNumber)])))
                    Slider(value: $viewModel.frequencyPickerNumber, in: 0...Double(viewModel.frequencies.count - 1), step: 1)
                        .disabled(viewModel.disableChoice)
                    
                    Text("Gain: " + String(Int(viewModel.gainValues[Int(viewModel.gainPickerNumber)])))
                    Slider(value: $viewModel.gainPickerNumber, in: 0...Double(viewModel.gainValues.count - 1), step: 1)
                        .disabled(viewModel.disableChoice)
                    
                    Text("Bandwidth: " + String(viewModel.bandwidths[Int(viewModel.bandwidthPickerNumber)]))
                    Slider(value: $viewModel.bandwidthPickerNumber, in: 0...Double(viewModel.bandwidths.count - 1), step: 1)
                        .disabled(viewModel.disableChoice)
                    
                    if viewModel.revealAnswer {
                        Text("TARGET: \(viewModel.target.frequency)")
                    }
                    
                    Picker("Select an EQ:", selection: $viewModel.loadedEQIndex) {
                        Text("TARGET EQ").tag(0)
                        Text("BYPASS").tag(1)
                        Text("USER EQ").tag(2)
                    }
                    .labelsHidden()
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Button("PLAYorPAUSE") {
                        viewModel.playOrPause()
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                .padding()
                .navigationTitle("Equalizer")
                .toolbar {
                    Button(action: {
                        menuOpened.toggle()
                    }, label: {
                        Text("Settings")
                            .frame(width: 100, height: 50, alignment: .center)
                            .foregroundColor(.white)
                            .background(.blue)
                            .cornerRadius(8)
                    })
                    
                }
            }
            SideBar(width: UIScreen.main.bounds.width/1.6, menuOpened: menuOpened, toggleMenu: toggleMenu)
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
