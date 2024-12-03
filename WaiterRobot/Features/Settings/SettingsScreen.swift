import shared
import SwiftUI
import UIPilot
import WRCore

struct SettingsScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @State private var showConfirmLogout = false
    @State private var showConfirmSkipMoneyBackDialog = false

    @StateObject private var viewModel = ObservableSettingsViewModel()

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
        List {
            general()

            payment()

            Section(header: Text(localize.settings.about.title())) {
                Link(localize.settings.about.privacyPolicy(), destination: URL(string: CommonApp.shared.privacyPolicyUrl)!)
            }

            HStack {
                Spacer()
                Text(viewModel.state.versionString)
                    .font(.footnote)
                Spacer()
            }
            .listRowBackground(Color.clear)
        }
        .navigationTitle(localize.settings.title())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showConfirmLogout = true
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                }
            }
        }
        .confirmationDialog(
            localize.settings.general.logout.title(value0: CommonApp.shared.settings.organisationName),
            isPresented: $showConfirmLogout,
            titleVisibility: .visible
        ) {
            Button(localize.settings.general.logout.action(), role: .destructive, action: { viewModel.actual.logout() })
            Button(localize.settings.general.keepLoggedIn(), role: .cancel, action: { showConfirmLogout = false })
        } message: {
            Text(localize.settings.general.logout.desc(value0: CommonApp.shared.settings.organisationName))
        }
        .confirmationDialog(
            localize.settings.payment.skipMoneyBackDialog.title(),
            isPresented: $showConfirmSkipMoneyBackDialog,
            titleVisibility: .visible
        ) {
            Button(localize.settings.payment.skipMoneyBackDialog.confirmAction(), role: .destructive) {
                viewModel.actual.toggleSkipMoneyBackDialog(value: true, confirmed: true)
            }
            Button(localize.dialog.cancel(), role: .cancel) {
                showConfirmSkipMoneyBackDialog = false
            }
        } message: {
            Text(localize.settings.payment.skipMoneyBackDialog.confirmDesc())
        }
        .withViewModel(viewModel, navigator) { effect in
            switch onEnum(of: effect) {
            case .confirmSkipMoneyBackDialog:
                showConfirmSkipMoneyBackDialog = true
            }

            return true
        }
    }

    private func general() -> some View {
        Section(header: Text(localize.settings.general.title())) {
            SettingsItem(
                icon: "rectangle.portrait.and.arrow.right",
                title: localize.settings.general.logout.action(),
                subtitle: "\"\(CommonApp.shared.settings.organisationName)\" / \"\(CommonApp.shared.settings.waiterName)\"",
                onClick: {
                    showConfirmLogout = true
                }
            )

            SettingsItem(
                icon: "person.3",
                title: localize.switchEvent.title(),
                subtitle: CommonApp.shared.settings.eventName,
                onClick: {
                    viewModel.actual.switchEvent()
                }
            )

            SwitchThemeView(
                initial: viewModel.state.currentAppTheme,
                onChange: viewModel.actual.switchTheme
            )

            SettingsItem(
                icon: "arrow.triangle.2.circlepath",
                title: localize.settings.general.refresh.title(),
                subtitle: localize.settings.general.refresh.desc(),
                onClick: {
                    viewModel.actual.refreshAll()
                }
            )
        }
    }

    private func payment() -> some View {
        Section(header: Text(localize.settings.payment.title())) {
            SettingsItem(
                icon: "dollarsign.arrow.circlepath",
                title: localize.settings.payment.skipMoneyBackDialog.title(),
                subtitle: localize.settings.payment.skipMoneyBackDialog.desc(),
                action: {
                    Toggle(
                        isOn: .init(
                            get: { viewModel.state.skipMoneyBackDialog },
                            set: { newValue in
                                let kotlinBool = KotlinBoolean(value: newValue)
                                viewModel.actual.toggleSkipMoneyBackDialog(value: kotlinBool, confirmed: false)
                            }
                        ),
                        label: {}
                    ).labelsHidden()
                },
                onClick: {
                    viewModel.actual.toggleSkipMoneyBackDialog(value: nil, confirmed: false)
                }
            )

            SettingsItem(
                icon: "checkmark.square",
                title: localize.settings.payment.selectAllProductsByDefault.title(),
                subtitle: localize.settings.payment.selectAllProductsByDefault.desc(),
                action: {
                    Toggle(
                        isOn: .init(
                            get: { viewModel.state.paymentSelectAllProductsByDefault },
                            set: { newValue in
                                let kotlinBool = KotlinBoolean(value: newValue)
                                viewModel.actual.togglePaymentSelectAllProductsByDefault(value: kotlinBool)
                            }
                        ),
                        label: {}
                    ).labelsHidden()
                },
                onClick: {
                    viewModel.actual.togglePaymentSelectAllProductsByDefault(value: nil)
                }
            )
        }
    }
}
