import shared
import SwiftUI
import UIPilot
import WRCore

struct RegisterScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @StateObject private var viewModel = ObservableRegisterViewModel()

    @State private var name: String = ""

    let deepLink: DeepLink.AuthRegisterLink

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
            Text(localize.register.name.desc())
                .font(.body)

            TextField(localize.register.name.title(), text: $name)
                .font(.body)
                .fixedSize()
                .padding()

            HStack {
                Button {
                    viewModel.actual.cancel()
                } label: {
                    Text(localize.dialog.cancel())
                }

                Spacer()

                Button {
                    viewModel.actual.onRegister(
                        name: name,
                        registerLink: deepLink
                    )
                } label: {
                    Text(localize.register.login())
                }
            }
            .padding()

            Label(localize.register.alreadyRegisteredInfo(), systemImage: "info.circle.fill")
        }
        .padding()
        .navigationBarHidden(true)
        .withViewModel(viewModel, navigator)
    }
}

#Preview {
    RegisterScreen(deepLink: DeepLink.AuthRegisterLink(token: "", apiBase: ""))
}
