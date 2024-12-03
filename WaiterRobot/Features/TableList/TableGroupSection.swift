import shared
import SharedUI
import SwiftUI
import WRCore

struct TableGroupSection: View {
    let tableGroup: TableGroup
    let onTableClick: (shared.Table) -> Void

    var body: some View {
        Section {
            ForEach(tableGroup.tables, id: \.id) { table in
                TableView(
                    text: table.number.description,
                    hasOrders: table.hasOrders,
                    backgroundColor: Color(hex: tableGroup.color),
                    onClick: {
                        onTableClick(table)
                    }
                )
                .padding(10)
            }
        } header: {
            HStack {
                if let background = Color(hex: tableGroup.color) {
                    title(backgroundColor: background)
                } else {
                    title(backgroundColor: .gray.opacity(0.3))
                }

                Spacer()
            }
            .padding(.vertical, 4)
            .background(Color.whiteBlack)
        }
    }

    private func title(backgroundColor: Color) -> some View {
        Text(tableGroup.name)
            .font(.title2)
            .foregroundStyle(backgroundColor.getContentColor(lightColorScheme: .black, darkColorScheme: .white))
            .padding(6)
            .background {
                RoundedRectangle(cornerRadius: 8.0)
                    .foregroundStyle(backgroundColor)
            }
    }
}

#Preview {
    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
        TableGroupSection(
            tableGroup: TableGroup(
                id: 1,
                name: "Test Group",
                eventId: 1,
                position: 1,
                color: nil,
                hidden: false,
                tables: [
                    shared.Table(id: 1, number: 1, groupName: "Test Group", hasOrders: true),
                    shared.Table(id: 2, number: 2, groupName: "Test Group", hasOrders: false),
                    shared.Table(id: 3, number: 3, groupName: "Test Group", hasOrders: false),
                    shared.Table(id: 4, number: 4, groupName: "Test Group", hasOrders: true),
                ]
            ),
            onTableClick: { _ in }
        )
    }
    .padding()
}
