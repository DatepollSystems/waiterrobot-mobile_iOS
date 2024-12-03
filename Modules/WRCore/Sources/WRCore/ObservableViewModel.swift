/// Base on
/// - https://johnoreilly.dev/posts/kotlinmultiplatform-swift-combine_publisher-flow/
/// - https://proandroiddev.com/kotlin-multiplatform-mobile-sharing-the-ui-state-management-a67bd9a49882
/// - https://github.com/orbit-mvi/orbit-swift-gradle-plugin/blob/main/src/main/resources/stateObject.swift.mustache

import Foundation
import shared

public class ObservableViewModel<State: ViewModelState, Effect: ViewModelEffect, ViewModel: AbstractViewModel<State, Effect>>: ObservableObject {
    @Published
    public private(set) var state: State

    public let actual: ViewModel

    public init(viewModel: ViewModel) {
        actual = viewModel
        // This is save, as the constraint is required by the generics (S must be the state of the provided VM)
        state = actual.container.stateFlow.value as! State
    }

    @MainActor
    public func activate() async {
        for await state in actual.container.refCountStateFlow {
            self.state = state as! State
        }
    }

    deinit {
        actual.onCleared()
    }
}

public class ObservableTableListViewModel: ObservableViewModel<TableListState, TableListEffect, TableListViewModel> {
    public init() {
        super.init(viewModel: koin.tableListVM())
    }
}

public class ObservableTableDetailViewModel: ObservableViewModel<TableDetailState, TableDetailEffect, TableDetailViewModel> {
    public init(table: Table) {
        super.init(viewModel: koin.tableDetailVM(table: table))
    }
}

public class ObservableRootViewModel: ObservableViewModel<RootState, RootEffect, RootViewModel> {
    public init() {
        super.init(viewModel: koin.rootVM())
    }
}

public class ObservableBillingViewModel: ObservableViewModel<BillingState, BillingEffect, BillingViewModel> {
    public init(table: Table) {
        super.init(viewModel: koin.billingVM(table: table))
    }
}

public class ObservableOrderViewModel: ObservableViewModel<OrderState, OrderEffect, OrderViewModel> {
    public init(table: Table, initialItemId: KotlinLong?) {
        super.init(viewModel: koin.orderVM(table: table, initialItemId: initialItemId))
    }
}

public class ObservableLoginScannerViewModel: ObservableViewModel<LoginScannerState, LoginScannerEffect, LoginScannerViewModel> {
    public init() {
        super.init(viewModel: koin.loginScannerVM())
    }
}

public class ObservableSettingsViewModel: ObservableViewModel<SettingsState, SettingsEffect, SettingsViewModel> {
    public init() {
        super.init(viewModel: koin.settingsVM())
    }
}

public class ObservableSwitchEventViewModel: ObservableViewModel<SwitchEventState, SwitchEventEffect, SwitchEventViewModel> {
    public init() {
        super.init(viewModel: koin.switchEventVM())
    }
}

public class ObservableRegisterViewModel: ObservableViewModel<RegisterState, RegisterEffect, RegisterViewModel> {
    public init() {
        super.init(viewModel: koin.registerVM())
    }
}

public class ObservableLoginViewModel: ObservableViewModel<LoginState, LoginEffect, LoginViewModel> {
    public init() {
        super.init(viewModel: koin.loginVM())
    }
}
