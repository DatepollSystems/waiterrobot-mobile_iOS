import shared
import SwiftUI

struct ProductSearch: View {
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var vm: OrderObservableViewModel

    @State private var search: String = ""
    @State private var selectedTab: Int = 0

    private let layout = [
        GridItem(.adaptive(minimum: 110)),
    ]

    var body: some View {
        NavigationView {
            if vm.state.productGroups.isEmpty {
                Text(localize.productSearch.noProductFound())
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                VStack {
                    ProducSearchTabBarHeader(currentTab: $selectedTab, tabBarOptions: getGroupNames(vm.state.productGroups))

                    TabView(selection: $selectedTab) {
                        ProductSearchAllTab(
                            productGroups: vm.state.productGroups,
                            columns: layout,
                            onProductClick: {
                                vm.actual.addItem(product: $0, amount: 1)
                                dismiss()
                            }
                        )
                        .tag(0)
                        .padding()

                        ForEach(Array(vm.state.productGroups.enumerated()), id: \.element.id) { index, groupWithProducts in
                            ScrollView {
                                LazyVGrid(columns: layout, spacing: 0) {
                                    ProductSearchGroupList(
                                        products: groupWithProducts.products,
                                        onProductClick: {
                                            vm.actual.addItem(product: $0, amount: 1)
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
                .onChange(of: search, perform: { vm.actual.filterProducts(filter: $0) })
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(localize.dialog.cancel()) {
                            dismiss()
                        }
                    }
                }
            }
        }
    }

    private func getGroupNames(_ productGroups: [ProductGroup]) -> [String] {
        var groupNames = productGroups.map { productGroup in
            productGroup.name
        }
        groupNames.insert(localize.productSearch.allGroups(), at: 0)
        return groupNames
    }
}
