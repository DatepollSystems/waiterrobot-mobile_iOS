//
//  ButtonStyles.swift
//  WaiterRobot
//
//  Created by Alexander Kauer on 25.02.24.
//

import SharedUI
import SwiftUI

struct WRBorderedProminentButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(isEnabled ? .white : .white.opacity(0.8))
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .ifCondition(isEnabled) { view in
                        view.foregroundStyle(configuration.isPressed ? Color.main.opacity(0.6) : Color.accentColor)
                    }
                    .ifCondition(!isEnabled) { view in
                        view.foregroundStyle(.gray)
                    }
            )
    }
}

extension ButtonStyle where Self == WRBorderedProminentButtonStyle {
    static var primary: WRBorderedProminentButtonStyle {
        WRBorderedProminentButtonStyle()
    }
}

struct WRSecondaryBorderedProminentButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(isEnabled ? .white : .white.opacity(0.8))
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .ifCondition(isEnabled) { view in
                        view.foregroundStyle(configuration.isPressed ? Color.accent : Color.accent.opacity(0.8))
                    }
                    .ifCondition(!isEnabled) { view in
                        view.foregroundStyle(.gray)
                    }
            )
    }
}

extension ButtonStyle where Self == WRSecondaryBorderedProminentButtonStyle {
    static var secondary: WRSecondaryBorderedProminentButtonStyle {
        WRSecondaryBorderedProminentButtonStyle()
    }
}

struct WRBorderedProminentGreyStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .ifCondition(isEnabled) { view in
                        view.foregroundStyle(configuration.isPressed ? .gray.opacity(0.6) : .gray.opacity(0.3))
                    }
                    .ifCondition(!isEnabled) { view in
                        view.foregroundStyle(.gray)
                    }
            )
    }
}

extension ButtonStyle where Self == WRBorderedProminentGreyStyle {
    static var gray: WRBorderedProminentGreyStyle {
        WRBorderedProminentGreyStyle()
    }
}

#Preview {
    VStack {
        Button {} label: {
            Text("Test")
                .padding()
        }
        .buttonStyle(.primary)

        Button {} label: {
            Text("Test")
                .padding()
        }
        .buttonStyle(.secondary)

        Button {} label: {
            Text("Test")
                .padding()
        }
        .buttonStyle(.gray)
    }
}
