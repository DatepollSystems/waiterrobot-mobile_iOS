//
//  FloatingActionButton.swift
//  WaiterRobot
//
//  Created by Alexander Kauer on 16.08.23.
//

import Foundation
import SwiftUI

struct EmbeddedFloatingActionButton: View {
    let icon: String
    let action: () -> Void

    var body: some View {
        VStack {
            Spacer()

            HStack {
                Spacer()

                FloatingActionButton(
                    icon: "plus",
                    action: action
                )
                .padding([.trailing, .bottom])
            }
        }
    }
}

struct FloatingActionButton: View {
    let icon: String
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                Circle()
                    .foregroundColor(.blue)
                    .imageScale(.small)

                Image(systemName: icon)
                    .imageScale(.large)
                    .foregroundColor(.white)
                // .fontWeight(.semibold) // TODO: enable when dropped ios 15
            }
        }
        .buttonStyle(FloatingActionButtonStyle())
        .frame(maxWidth: 52)
    }
}

struct FloatingActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.85 : 1.0)
            .animation(.easeIn(duration: 0.1), value: configuration.isPressed)
            .opacity(configuration.isPressed ? 0.6 : 1)
    }
}

#Preview {
    ZStack {
        EmbeddedFloatingActionButton(
            icon: "plus",
            action: {
                print("Test")
            }
        )
    }
}
