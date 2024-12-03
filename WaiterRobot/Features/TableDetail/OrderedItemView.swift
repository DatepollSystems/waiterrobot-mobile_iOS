import shared
import SwiftUI

struct OrderedItemView: View {
    let item: OrderedItem
    let tabbed: () -> Void

    var body: some View {
        Button {
            tabbed()
        } label: {
            HStack {
                Text("\(item.amount) x")
                Spacer()
                Text(item.name)
            }
        }
        .foregroundColor(.blackWhite)
    }
}

#Preview {
    List {
        OrderedItemView(
            item: OrderedItem(
                baseProductId: 1,
                name: "Test",
                amount: 1,
                virtualId: 2
            ),
            tabbed: {}
        )
    }
}
