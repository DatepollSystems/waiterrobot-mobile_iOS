import shared
import SwiftUI

struct BillListItem: View {
    let item: BillItem

    let addOne: () -> Void
    let addAll: () -> Void
    let removeOne: () -> Void
    let removeAll: () -> Void

    var body: some View {
        Button(action: {
            addOne()
        }) {
            HStack {
                Text("\(item.ordered) x \(item.name)")
                Spacer()
                Text(item.selectedForBill.description)

                Text(item.priceSum.description)
                    .frame(minWidth: 70, alignment: .trailing)
                    .padding(.leading)
            }
        }
        .foregroundColor(.blackWhite)
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            HStack {
                Button(action: {
                    addOne()
                }, label: {
                    Image(systemName: "plus")
                })
                .tint(.gray)

                Button(action: {
                    addAll()
                }, label: {
                    Image(systemName: "checkmark")
                })
                .tint(.green)
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            HStack {
                Button(action: {
                    removeOne()
                }, label: {
                    Image(systemName: "minus")
                })
                .tint(.gray)

                Button(action: {
                    withAnimation(.spring()) {
                        removeAll()
                    }
                }, label: {
                    Image(systemName: "trash")
                })
                .tint(.red)
            }
        }
    }
}

#Preview {
    List {
        BillListItem(
            item: BillItem(
                baseProductId: 1,
                name: "Beer",
                ordered: 10,
                selectedForBill: 5,
                pricePerPiece: Money(cents: 3390),
                orderProductIds: [1, 2]
            ),
            addOne: {},
            addAll: {},
            removeOne: {},
            removeAll: {}
        )
        BillListItem(
            item: BillItem(
                baseProductId: 2,
                name: "Wine",
                ordered: 15,
                selectedForBill: 8,
                pricePerPiece: Money(cents: 390),
                orderProductIds: [1, 2]
            ),
            addOne: {},
            addAll: {},
            removeOne: {},
            removeAll: {}
        )
    }
}
