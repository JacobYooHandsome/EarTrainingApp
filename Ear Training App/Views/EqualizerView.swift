//
//  ContentView.swift
//  Ear Training App
//
//  Created by Jacob Yoo on 3/11/24.
//

import SwiftUI

extension Float {
    func decimalConversion(_ number: Int) -> String {
        String(self.formatted(.number.precision(.fractionLength(number))))
    }
}

struct EqualizerSideBarSettings: View {
    @ObservedObject var viewModel: EqualizerViewModel
    
    var body: some View {
        ZStack {
            Color(.darkGray)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Frequency Resolution").bold()
                Picker(selection: $viewModel.frequencyResolutionPicker, content: {
                    ForEach(viewModel.frequencyResolutions, id:\.self) { reso in
                        if reso == 1 {
                            Text("1 Octave").tag(reso)
                        } else {
                            Text("1/3 Octave").tag(reso)
                        }
                    }
                }, label: {EmptyView()})
                    .background(.white)
                    .cornerRadius(8)
                    .padding(2)
                
                Divider()
                    .overlay(Color.white)
                
                Text("Gain Range").bold()
                Picker(selection: $viewModel.gainRangePicker, content: {
                    ForEach(viewModel.gainRanges, id:\.self) { range in
                        if range.count == 2 {
                            if range[1] > 1 {
                                Text("+\(range[1].decimalConversion(1)) ONLY").tag(range)
                            } else {
                                Text("\(range[0].decimalConversion(1)) ONLY").tag(range)
                            }
                        } else if range.count == 3 {
                            Text("\(range[0].decimalConversion(1))/+\(range[2].decimalConversion(1))").tag(range)
                        } else {
                            Text("All combinations").tag(range)
                        }
            
                    }
                }, label: {EmptyView()})
                    .background(.white)
                    .cornerRadius(8)
                    .padding(2)
                
                Divider()
                    .overlay(Color.white)
                
                Text("Bandwidth").bold()
                Picker(selection: $viewModel.bandwidthRangePicker, content: {
                    Text("1.5").tag(0)
                    Text("3.0").tag(1)
                }, label: {EmptyView()})
                    .background(.white)
                    .cornerRadius(8)
                    .padding(2)
                
                Divider()
                    .overlay(Color.white)
                
                Text("Number of Bands").bold()
                Picker(selection: $viewModel.numOfBandsPicker, content: {
                    Text("One Band").tag(0)
                    Text("Two Bands").tag(1)
                    Text("Three Bands").tag(2)
                }, label: {EmptyView()})
                    .background(.white)
                    .cornerRadius(8)
                    .padding(2)
                
                Divider()
                    .overlay(Color.white)
                
                Text("Frequency Range").bold()
                HStack {
                    Picker(selection: $viewModel.numOfBandsPicker, content: {
                        Text("63").tag(0)
                    }, label: {Text("START")})
                        .background(.white)
                        .cornerRadius(8)
                        .padding(2)
                    Picker(selection: $viewModel.numOfBandsPicker, content: {
                        Text("16000").tag(0)
                    }, label: {Text("END")})
                        .background(.white)
                        .cornerRadius(8)
                        .padding(2)
                }
                Spacer()
            }
            .fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: false)
            .safeAreaPadding(.top, 60)
            .foregroundColor(.white)
        }
    }
}

struct SideBar: View {
    @ObservedObject var viewModel: EqualizerViewModel
    let width: CGFloat
    let menuOpened: Bool
    let toggleMenu: () -> Void
    
    var body: some View {
        ZStack {
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.gray.opacity(0.5))
            .opacity(self.menuOpened ? 1 : 0)
            .animation(.easeIn.delay(0.25), value: self.menuOpened)
            .onTapGesture {
                self.toggleMenu()
            }
            HStack {
                EqualizerSideBarSettings(viewModel: viewModel)
                    .frame(width: width)
                    .offset(x: menuOpened ? 0 : -width)
                    .animation(.default, value: self.menuOpened)
                Spacer()
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
                    
                    Text("USER DEBUG: \(Int(viewModel.userEQ.frequency))hz")
                    Text("USER DEBUG: \(Int(viewModel.userEQ.gain))db")
                    
                    if viewModel.revealAnswer {
                        Text("TARGET: \(Int(viewModel.targetEQ.frequency))hz")
                        Text("USER: \(Int(viewModel.userEQ.frequency))hz")
                    }
                    
                    Spacer()
                    
                    Text("Frequency: " + String(Int(viewModel.frequencies[Int(viewModel.frequencyPicker)])))
                    Slider(value: $viewModel.frequencyPicker, in: 0...Double(viewModel.frequencies.count - 1), step: 1)
                        .disabled(viewModel.disableChoice)
                    
                    Text("Gain: " + String(Int(viewModel.gainValues[Int(viewModel.gainPicker)])))
                    Slider(value: $viewModel.gainPicker, in: 0...Double(viewModel.gainValues.count - 1), step: 1)
                        .disabled(viewModel.disableChoice)
                    
                    Text("Bandwidth: " + String(viewModel.bandwidths[Int(viewModel.bandwidthPicker)]))
                    Slider(value: $viewModel.bandwidthPicker, in: 0...Double(viewModel.bandwidths.count - 1), step: 1)
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
