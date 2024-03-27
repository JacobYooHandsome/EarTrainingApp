//
//  SideBarView.swift
//  Ear Training App
//
//  Created by Jacob Yoo on 3/27/24.
//

import SwiftUI

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

#Preview {
    SideBar(viewModel: EqualizerViewModel())
}
