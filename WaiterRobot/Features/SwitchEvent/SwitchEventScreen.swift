import shared
import SwiftUI
import UIPilot
import WRCore

struct SwitchEventScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @StateObject private var viewModel = ObservableSwitchEventViewModel()

    @State private var selectedEvent: Event?

    var body: some View {
        VStack {
            switch onEnum(of: viewModel.state.viewState) {
            case .loading:
                ProgressView()
            case .idle:
                content()
            case let .error(error):
                content()
                    .alert(isPresented: Binding.constant(true)) {
                        Alert(
                            title: Text(error.title),
                            message: Text(error.message),
                            dismissButton: .cancel(Text("OK"), action: error.onDismiss)
                        )
                    }
            }
        }.withViewModel(viewModel, navigator)
    }

    private func content() -> some View {
        VStack {
            Image(systemName: "person.3")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 100)
                .padding()

            Text(localize.switchEvent.desc())
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding()

            Divider()

            ScrollView {
                if viewModel.state.events.isEmpty {
                    Text(localize.switchEvent.noEventFound())
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    LazyVStack {
                        ForEach(viewModel.state.events, id: \.id) { event in
                            Button {
                                viewModel.actual.onEventSelected(event: event)
                            } label: {
                                Event(event: event)
                                    .padding(.horizontal)
                            }.foregroundColor(.blackWhite)
                            Divider()
                        }
                    }
                }
            }
            .refreshable {
                viewModel.actual.loadEvents()
            }
        }
    }
}

#Preview {
    SwitchEventScreen()
}
