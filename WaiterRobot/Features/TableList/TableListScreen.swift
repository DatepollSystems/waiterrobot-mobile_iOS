import shared
import SwiftUI
import UIPilot
import WRCore

struct TableListScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @StateObject private var viewModel = ObservableTableListViewModel()

    @State
    private var showFilters = false

    var body: some View {
        VStack {
            if #available(iOS 16.0, *) {
                content()
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                viewModel.actual.openSettings()
                            } label: {
                                Image(systemName: "gear")
                            }
                        }
                    }
                    .toolbarBackground(.hidden, for: .navigationBar)
            } else {
                content()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                viewModel.actual.openSettings()
                            } label: {
                                Image(systemName: "gear")
                            }
                        }
                    }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    HStack(spacing: 0) {
                        Text("kellner.")
                            .textStyle(.h4, textColor: .title)

                        Text("team")
                            .textStyle(.h4, textColor: .palletOrange)
                    }

                    Text(CommonApp.shared.settings.eventName)
                        .textStyle(.caption1)
                        .padding(.bottom, 6)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .animation(.spring, value: viewModel.state.tableGroupsArray)
        .withViewModel(viewModel, navigator)
    }

    private func content() -> some View {
        ZStack {
            if let data = viewModel.state.tableGroupsArray.data {
                tableList(data: data)
            }

            switch onEnum(of: viewModel.state.tableGroupsArray) {
            case let .error(resource):
                VStack {
                    Spacer()

                    HStack {
                        Text(resource.userMessage)
                            .padding()

                        Spacer()
                    }
                    .background(.red)
                    .foregroundStyle(.white)
                }
                .transition(.move(edge: .bottom))

            case let .loading(resource):
                if resource.data == nil {
                    ProgressView()
                }

            case .success:
                EmptyView()
            }
        }
    }

    @ViewBuilder
    private func tableList(data: KotlinArray<TableGroup>) -> some View {
        let tableGroups = Array(data)

        TableListView(
            showFilters: $showFilters,
            tableGroups: tableGroups,
            onToggleFilter: { viewModel.actual.toggleFilter(tableGroup: $0) },
            onSelectAll: { viewModel.actual.showAll() },
            onUnselectAll: { viewModel.actual.hideAll() },
            onTableSelect: { viewModel.actual.onTableClick(table: $0) }
        )
    }
}

struct TableListView: View {
    @Binding var showFilters: Bool
    let tableGroups: [TableGroup]
    let onToggleFilter: (TableGroup) -> Void
    let onSelectAll: () -> Void
    let onUnselectAll: () -> Void
    let onTableSelect: (shared.Table) -> Void

    private let layout = [
        GridItem(.adaptive(minimum: 100)),
    ]

    var body: some View {
        VStack(spacing: 0) {
            if tableGroups.count > 1, showFilters {
                VStack {
                    TableListFilterRow(
                        tableGroups: tableGroups,
                        onToggleFilter: onToggleFilter,
                        onSelectAll: onSelectAll,
                        onUnselectAll: onUnselectAll
                    )
                }
                .padding()
                .background(Color(UIColor.systemBackground))
            }

            Divider()

            if tableGroups.isEmpty {
                Spacer()

                Text(localize.tableList.noTableFound())
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding()

                Spacer()
            } else {
                ScrollView {
                    LazyVGrid(
                        columns: layout,
                        pinnedViews: [.sectionHeaders]
                    ) {
                        ForEach(tableGroups.filter { !$0.hidden }, id: \.id) { group in
                            if !group.tables.isEmpty {
                                TableGroupSection(
                                    tableGroup: group,
                                    onTableClick: onTableSelect
                                )
                            }
                        }
                    }
                    .padding()
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        if tableGroups.count > 1 {
                            Button {
                                showFilters.toggle()
                            } label: {
                                Image(systemName: "slider.horizontal.3")
                            }
                        }
                    }
                }
            }
        }
        .animation(.easeIn, value: showFilters)
    }
}

#Preview("TableListScreen") {
    PreviewView {
        NavigationView {
            TableListScreen()
        }
    }
}

#Preview("TableListView") {
    PreviewView {
        NavigationView {
            TableListView(
                showFilters: .constant(false),
                tableGroups: Mock.tableGroups()
            ) { _ in

            } onSelectAll: {} onUnselectAll: {} onTableSelect: { _ in
            }
        }
    }
}
