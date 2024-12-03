import shared
import SwiftUI

struct TableListFilterRow: View {
    let tableGroups: [TableGroup]
    let onToggleFilter: (TableGroup) -> Void
    let onSelectAll: () -> Void
    let onUnselectAll: () -> Void

    var body: some View {
        if #available(iOS 16, *) {
            newFilter()
        } else {
            oldFilter()
        }
    }

    @available(iOS 16, *)
    private func newFilter() -> some View {
        VStack(spacing: 20) {
            DynamicGrid(
                horizontalSpacing: 5,
                verticalSpacing: 5
            ) {
                ForEach(tableGroups, id: \.id) { group in
                    if group.hidden {
                        Button {
                            onToggleFilter(group)
                        } label: {
                            Text(group.name)
                                .padding()
                        }
                        .buttonStyle(.gray)
                    } else {
                        Button {
                            onToggleFilter(group)
                        } label: {
                            Text(group.name)
                                .padding()
                        }
                        .buttonStyle(.primary)
                    }
                }
            }

            HStack {
                Button {
                    onSelectAll()
                } label: {
                    Image(systemName: "rectangle.badge.checkmark")
                        .imageScale(.large)
                        .padding(8)
                }
                .buttonStyle(.primary)

                Button {
                    onUnselectAll()
                } label: {
                    Image(systemName: "rectangle.badge.xmark")
                        .imageScale(.large)
                        .padding(8)
                }
                .buttonStyle(.gray)
            }
            .frame(maxWidth: .infinity)
        }
    }

    private func oldFilter() -> some View {
        HStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(tableGroups, id: \.id) { group in
                        Button {
                            onToggleFilter(group) // viewModel.actual.toggleFilter(tableGroup: group)
                        } label: {
                            Text(group.name)
                        }
                        .buttonStyle(.bordered)
                        .tint(group.hidden ? .primary : .blue)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 4)

            Button {
                onSelectAll()
            } label: {
                Image(systemName: "checkmark")
            }
            .padding(.trailing)
            .disabled(tableGroups.allSatisfy { !$0.hidden })

            Button {
                onUnselectAll()
            } label: {
                Image(systemName: "xmark")
            }
            .padding(.trailing)
            .disabled(tableGroups.allSatisfy(\.hidden))
        }
    }
}

#Preview {
    TableListFilterRow(
        tableGroups: [
            TableGroup(id: 1, name: "Test Group1", eventId: 1, position: 1, color: nil, hidden: true, tables: []),
            TableGroup(id: 2, name: "Test Group2", eventId: 1, position: 1, color: nil, hidden: false, tables: []),
        ],
        onToggleFilter: { _ in },
        onSelectAll: {},
        onUnselectAll: {}
    )
    .padding()
}
