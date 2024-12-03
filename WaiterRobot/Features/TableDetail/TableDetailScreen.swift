import shared
import SwiftUI
import UIPilot
import WRCore

struct TableDetailScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @StateObject private var viewModel: ObservableTableDetailViewModel
    private let table: shared.Table

    init(table: shared.Table) {
        self.table = table
        _viewModel = StateObject(
            wrappedValue: ObservableTableDetailViewModel(table: table)
        )
    }

    var body: some View {
        content()
            .navigationTitle(localize.tableDetail.title(value0: table.groupName, value1: table.number.description))
            .withViewModel(viewModel, navigator)
    }

    // TODO: add refreshing and loading indicator (also check android)
    private func content() -> some View {
        VStack {
            switch onEnum(of: viewModel.state.orderedItemsResource) {
            case .loading:
                ProgressView()

            case let .error(error):
                tableDetailsError(error)

            case let .success(resource):
                if let orderedItems = resource.data as? [OrderedItem] {
                    tableDetails(orderedItems: orderedItems)
                }
            }
        }
    }

    private func tableDetails(orderedItems: [OrderedItem]) -> some View {
        // TODO: we need KotlinArray here in shared
        VStack {
            if orderedItems.isEmpty {
                Spacer()

                Text(localize.tableDetail.noOrder(value0: table.groupName, value1: table.number.description))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding()

                Spacer()
            } else {
                List {
                    ForEach(orderedItems, id: \.virtualId) { item in
                        OrderedItemView(item: item) {
                            viewModel.actual.openOrderScreen(initialItemId: item.baseProductId.toKotlinLong())
                        }
                    }
                }
            }
        }
        .wrBottomBar {
            Button {
                viewModel.actual.openBillingScreen()
            } label: {
                Image(systemName: "creditcard")
                    .padding(10)
            }
            .buttonStyle(.primary)
            .disabled(orderedItems.isEmpty)

            Spacer()

            Button {
                viewModel.actual.openOrderScreen(initialItemId: nil)
            } label: {
                Image(systemName: "plus")
                    .imageScale(.large)
                    .padding()
            }
            .buttonStyle(.primary)
        }
    }

    private func tableDetailsError(_ error: ResourceError<NSArray>) -> some View {
        Text(error.userMessage)
    }
}
