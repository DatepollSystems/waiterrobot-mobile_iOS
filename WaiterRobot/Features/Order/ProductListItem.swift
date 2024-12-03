import shared
import SwiftUI

struct ProductListItem: View {
    let product: Product
    let backgroundColor: Color?
    let onClick: () -> Void

    private let allergens: String

    init(
        product: Product,
        backgroundColor: Color?,
        onClick: @escaping () -> Void
    ) {
        self.product = product
        self.backgroundColor = backgroundColor
        self.onClick = onClick

        var allergens = ""
        for allergen in self.product.allergens {
            allergens += "\(allergen.shortName), "
        }

        if allergens.count > 2 {
            self.allergens = String(allergens.prefix(allergens.count - 2))
        } else {
            self.allergens = ""
        }
    }

    var foregroundColor: Color {
        if product.soldOut {
            .blackWhite
        } else if let backgroundColor {
            backgroundColor.getContentColor(lightColorScheme: .black, darkColorScheme: .white)
        } else {
            .blackWhite
        }
    }

    var body: some View {
        Button {
            onClick()
        } label: {
            VStack {
                Text(product.name)
                    .strikethrough(product.soldOut)
                    .foregroundStyle(foregroundColor)
                if !product.allergens.isEmpty {
                    Text(allergens)
                        .foregroundStyle(foregroundColor)
                        .opacity(0.6)
                }
                Text(product.price.description())
            }
            .foregroundStyle(foregroundColor)
            .frame(maxWidth: .infinity)
            .padding(5)
        }
        .disabled(product.soldOut)
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(product.soldOut ? Color.gray.opacity(0.1) : backgroundColor ?? Color(.systemBackground))
                .shadow(radius: 2)
        }
    }
}

#Preview {
    ProductListItem(
        product: Product(
            id: 2,
            name: "Wine",
            price: Money(cents: 290),
            soldOut: true,
            color: nil,
            allergens: [
                Allergen(id: 1, name: "Egg", shortName: "E"),
                Allergen(id: 2, name: "Egg2", shortName: "A"),
                Allergen(id: 3, name: "Egg3", shortName: "B"),
                Allergen(id: 4, name: "Egg4", shortName: "C"),
                Allergen(id: 5, name: "Egg5", shortName: "D"),
            ],
            position: 1
        ),
        backgroundColor: .yellow,
        onClick: {}
    )
    .frame(maxWidth: 100, maxHeight: 100)
}

#Preview {
    ProductListItem(
        product: Product(
            id: 2,
            name: "Wine",
            price: Money(cents: 290),
            soldOut: false,
            color: nil,
            allergens: [
                Allergen(id: 1, name: "Egg", shortName: "E"),
                Allergen(id: 2, name: "Egg2", shortName: "A"),
                Allergen(id: 3, name: "Egg3", shortName: "B"),
                Allergen(id: 4, name: "Egg4", shortName: "C"),
                Allergen(id: 5, name: "Egg5", shortName: "D"),
            ],
            position: 1
        ),
        backgroundColor: .yellow,
        onClick: {}
    )
    .frame(maxWidth: 100, maxHeight: 100)
}
