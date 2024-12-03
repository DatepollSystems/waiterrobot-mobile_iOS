import Foundation
import shared
import SharedUI
import SwiftUI
import UIPilot
import WRCore

struct LoginScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @StateObject private var viewModel = ObservableLoginViewModel()
    @State private var showLinkInput = false
    @State private var debugLoginLink = ""

    var body: some View {
        switch viewModel.state.viewState {
        case is ViewState.Loading:
            ProgressView()
        case is ViewState.Idle:
            content()
        case let error as ViewState.Error:
            content()
                .alert(isPresented: Binding.constant(true)) {
                    Alert(
                        title: Text(error.title),
                        message: Text(error.message),
                        dismissButton: .cancel(Text("OK"), action: error.onDismiss)
                    )
                }
        default:
            fatalError("Unexpected ViewState: \(viewModel.state.viewState.description)")
        }
    }

    private func content() -> some View {
        VStack {
            Spacer()

            Image.logoRounded
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 250)
                .padding()
                .onLongPressGesture {
                    showLinkInput = true
                }
            Text(localize.login.title())
                .font(.title)
                .padding()

            Text(localize.login.desc())
                .font(.body)
                .padding()
                .multilineTextAlignment(.center)

            Button {
                viewModel.actual.openScanner()
            } label: {
                Label(localize.login.withQrCode(), systemImage: "qrcode.viewfinder")
                    .font(.title3)
            }
            .padding()

            Spacer()
        }
        .alert(localize.login.title(), isPresented: $showLinkInput) {
            TextField(localize.login.debugDialog.inputLabel(), text: $debugLoginLink)
            Button(localize.dialog.cancel(), role: .cancel) {
                showLinkInput = false
            }
            Button(localize.login.title()) {
                viewModel.actual.onDebugLogin(link: debugLoginLink)
            }
        }
        .withViewModel(viewModel, navigator)
    }
}

#Preview {
    PreviewView {
        LoginScreen()
    }
}
