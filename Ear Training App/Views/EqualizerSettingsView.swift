//
//  EqualizerSettings.swift
//  Ear Training App
//
//  Created by Jacob Yoo on 3/26/24.
//

import SwiftUI

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
                Picker(selection: $viewModel.bandwidthPicker, content: {
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

extension Float {
    func decimalConversion(_ number: Int) -> String {
        String(self.formatted(.number.precision(.fractionLength(number))))
    }
}

#Preview {
    EqualizerSideBarSettings(viewModel: EqualizerViewModel())
}
