import Foundation
import shared
import SwiftUI
import UIPilot

extension UIPilot<Screen> {
    @MainActor
    func navigate(_ navAction: NavAction) {
        koin.logger(tag: "Navigation").d { "Handle navigation: \(navAction.description)" }

        switch onEnum(of: navAction) {
        case .pop:
            pop()

        case let .push(nav):
            push(nav.screen)

        case let .popUpTo(nav):
            popTo(nav.screen, inclusive: nav.inclusive)

        case let .popUpAndPush(nav):
            popTo(nav.popUpTo, inclusive: nav.inclusive)
            push(nav.screen)

        case let .replaceRoot(nav):
            guard let topmost = topmostScreen else { return }
            popTo(topmost, inclusive: true)
            push(nav.screen)
        }
    }

    var topmostScreen: Screen? {
        stack.first
    }
}

public extension View {
    func customBackNavigation(
        title: String = localize.navigation.back(),
        icon: String? = "chevron.left",
        action: @escaping () -> Void
    ) -> some View {
        navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: action) {
                        HStack(spacing: 0) {
                            if let icon {
                                HStack {
                                    Image(systemName: icon)
                                    // .fontWeight(.semibold) // TODO: enable when dropped iOS15
                                }
                                .padding(.trailing, 4)
                            }

                            Text(title)
                        }
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.primary)
                }
            }
    }

    func handleSideEffects<State, SideEffect>(
        of viewModel: some ObservableViewModel<State, SideEffect, some AbstractViewModel<State, SideEffect>>,
        _ navigator: UIPilot<Screen>,
        handler: ((SideEffect) -> Bool)? = nil
    ) -> some View where State: ViewModelState, SideEffect: ViewModelEffect {
        task {
            let logger = koin.logger(tag: "handleSideEffects")
            for await sideEffect in viewModel.actual.container.refCountSideEffectFlow {
                logger.d { "Got sideEffect: \(sideEffect)" }
                switch onEnum(of: sideEffect as! NavOrViewModelEffect<SideEffect>) {
                case let .navEffect(navEffect):
                    await navigator.navigate(navEffect.action)
                case let .vMEffect(effect):
                    if handler?(effect.effect) != true {
                        logger.w { "Side effect \(effect.effect) was not handled." }
                    }
                }
            }
        }
    }

    func observeState<State, SideEffect>(
        of viewModel: some ObservableViewModel<State, SideEffect, some AbstractViewModel<State, SideEffect>>
    ) -> some View where State: ViewModelState, SideEffect: ViewModelEffect {
        task {
            await viewModel.activate()
        }
    }

    func withViewModel<State, SideEffect>(
        _ viewModel: some ObservableViewModel<State, SideEffect, some AbstractViewModel<State, SideEffect>>,
        _ navigator: UIPilot<Screen>,
        handler: ((SideEffect) -> Bool)? = nil
    ) -> some View where State: ViewModelState, SideEffect: ViewModelEffect {
        handleSideEffects(of: viewModel, navigator, handler: handler)
            .observeState(of: viewModel)
    }
}
