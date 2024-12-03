import Foundation
import shared
import SharedUI
import SwiftUI
import WRCore

struct LaunchScreen: View {
    @Environment(\.isPreview) private var isPreview

    private let minimumOnScreenTimeSeconds = 3.0

    @State private var startupFinished = false
    @State private var showProgressView = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Image.logoRounded
                    .resizable()
                    .scaledToFit()
                    .frame(width: 280, height: 280)
                    .ignoresSafeArea()
                    .padding(.bottom, 23)
                    .transition(.slide)

                if showProgressView {
                    ProgressView()
                        .padding()
                        .foregroundStyle(.green)
                }
            }

            if startupFinished {
                MainView()
            }
        }
        .animation(.spring, value: startupFinished)
        .animation(.spring, value: showProgressView)
        .task {
            defer {
                print("Show progress")
                showProgressView = true
            }

            do {
                try await Task.sleep(seconds: 0.1)
            } catch {}
        }
        .task {
            // This is needed otherwise previews will crash randomly
            if !isPreview {
                async let setup: () = WRCore.setup()
                async let delay: () = delay()

                await setup
                await delay

                startupFinished = true
            } else {
                print("Running from preview, skipping init")
            }
        }
    }

    private func delay() async {
        print("started delay")
        try? await Task.sleep(seconds: minimumOnScreenTimeSeconds)
        print("finished delay")
    }
}

#Preview {
//    PreviewView {
    LaunchScreen()
//    }
}
