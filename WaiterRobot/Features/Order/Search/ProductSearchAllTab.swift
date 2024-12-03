import shared
import SwiftUI

struct ProductSearchAllTab: View {
    let productGroups: [ProductGroup]
    let columns: [GridItem]
    let onProductClick: (Product) -> Void

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(productGroups, id: \.id) { productGroup in
                    if !productGroup.products.isEmpty {
                        Section {
                            ProductSearchGroupList(
                                products: productGroup.products,
                                backgroundColor: Color(hex: productGroup.color),
                                onProductClick: onProductClick
                            )
                        } header: {
                            HStack {
                                Color(UIColor.lightGray).frame(height: 1)
                                Text(productGroup.name)
                                Color(UIColor.lightGray).frame(height: 1)
                            }
                        }
                    }
                }
                Spacer()
            }
        }
    }
}

#Preview {
    ProductSearchAllTab(
        productGroups: [
            ProductGroup(
                id: 1,
                name: "Test Group 1",
                position: 1,
                color: "",
                products: [
                    Product(
                        id: 1,
                        name: "Beer",
                        price: Money(cents: 450),
                        soldOut: false,
                        color: nil,
                        allergens: [],
                        position: 1
                    ),
                ]
            ),
        ],
        columns: [GridItem(.adaptive(minimum: 110))],
        onProductClick: { _ in }
    )
    .padding()
}
