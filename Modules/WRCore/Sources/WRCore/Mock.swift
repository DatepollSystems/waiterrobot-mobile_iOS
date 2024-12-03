import Foundation
import shared

public enum Mock {
    public static func tableGroups() -> [TableGroup] {
        [
            tableGroup(with: 1, name: "Hof"),
            tableGroup(with: 2, name: "Terasse"),
            tableGroup(with: 3, name: "Zimmer A"),
        ]
    }

    public static func tableGroup(with id: Int64, name: String = "Hof") -> TableGroup {
        TableGroup(
            id: id,
            name: name,
            eventId: 1,
            position: Int32(id),
            color: "",
            hidden: false,
            tables: [
                table(with: 1),
                table(with: 2, hasOrders: true),
                table(with: 3),
                table(with: 4),
                table(with: 5),
                table(with: 6),
            ]
        )
    }

    public static func table(with id: Int64, hasOrders: Bool = false) -> shared.Table {
        shared.Table(
            id: id,
            number: Int32(id),
            groupName: "Hof",
            hasOrders: hasOrders
        )
    }
}
