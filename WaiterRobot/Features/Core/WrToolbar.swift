//
//  WrToolbar.swift
//  WaiterRobot
//
//  Created by Alexander Kauer on 25.02.24.
//

import SwiftUI

extension View {
    func wrBottomBar<ToolbarView: View>(@ViewBuilder toolbar: @escaping () -> ToolbarView) -> some View {
        modifier(WrToolbarModifier<ToolbarView>(toolbar: toolbar))
    }
}

struct WrToolbarModifier<ToolbarView: View>: ViewModifier {
    @ViewBuilder
    let toolbar: ToolbarView

    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            content

            VStack {
                Divider()

                HStack {
                    toolbar
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .padding(.top, 4)
            }
        }
    }
}

#Preview {
    Text("hello")
        .wrBottomBar {
            Button {} label: {
                Image(systemName: "creditcard")
                    .padding(12)
            }
            .buttonStyle(.primary)

            Button {} label: {
                Image(systemName: "plus")
                    .imageScale(.large)
                    .padding()
            }
            .buttonStyle(.primary)

            Button {} label: {
                Image(systemName: "plus")
                    .imageScale(.large)
                    .padding()
            }
            .buttonStyle(.primary)
            .disabled(true)
        }
}
