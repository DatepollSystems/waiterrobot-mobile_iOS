import shared
import SwiftUI
import WRCore

struct ProductSearch: View {
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var viewModel: ObservableOrderViewModel

    @State private var search: String = ""
    @State private var selectedTab: Int = 0

    private let layout = [
        GridItem(.adaptive(minimum: 110)),
    ]

    var body: some View {
        NavigationView {
            switch onEnum(of: viewModel.state.productGroups) {
            case .loading:
                ProgressView()
            case let .error(resource):
                productGroupsError(error: resource)
            case let .success(resource):
                if let productGroups = resource.data {
                    productsGroupsList(productGroups: productGroups)
                }
            }
        }.observeState(of: viewModel)
    }

    @ViewBuilder
    private func productsGroupsList(productGroups: KotlinArray<ProductGroup>) -> some View {
        let productGroups = Array(productGroups)

        if productGroups.isEmpty {
            Text(localize.productSearch.noProductFound())
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding()

        } else {
            VStack {
                ProducSearchTabBarHeader(currentTab: $selectedTab, tabBarOptions: getGroupNames(productGroups))

                TabView(selection: $selectedTab) {
                    ProductSearchAllTab(
                        productGroups: productGroups,
                        columns: layout,
                        onProductClick: {
                            viewModel.actual.addItem(product: $0, amount: 1)
                            dismiss()
                        }
                    )
                    .tag(0)
                    .padding()

                    let enumeratedProductGroups = Array(productGroups.enumerated())
                    ForEach(enumeratedProductGroups, id: \.element.id) { index, groupWithProducts in
                        ScrollView {
                            LazyVGrid(columns: layout, spacing: 0) {
                                ProductSearchGroupList(
                                    products: groupWithProducts.products,
                                    backgroundColor: Color(hex: groupWithProducts.color),
                                    onProductClick: {
                                        viewModel.actual.addItem(product: $0, amount: 1)
                                        dismiss()
                                    }
                                )
                                Spacer()
                            }
                            .padding()
                        }
                        .tag(index + 1)
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .always))
            .onChange(of: search, perform: { viewModel.actual.filterProducts(filter: $0) })
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(localize.dialog.cancel()) {
                        dismiss()
                    }
                }
            }
        }
    }

    private func productGroupsError(error: ResourceError<KotlinArray<ProductGroup>>) -> some View {
        Text(error.userMessage)
    }

    private func getGroupNames(_ productGroups: [ProductGroup]) -> [String] {
        var groupNames = productGroups.map { productGroup in
            productGroup.name
        }
        groupNames.insert(localize.productSearch.allGroups(), at: 0)
        return groupNames
    }
}
