import SwiftUI
import shared

struct ProductSearch: View {
  @Environment(\.dismiss) private var dismiss
  
  @ObservedObject var vm: ObservableViewModel<OrderState, OrderEffect, OrderViewModel>
  
  @State private var search: String = ""
  @State private var selectedTab: Int = 0
  
  private let layout = [
    GridItem(.adaptive(minimum: 110))
  ]
  
  var body: some View {
    NavigationView {
      if(vm.state.productGroups.isEmpty) {
        Text(S.productSearch.noProductFound())
          .multilineTextAlignment(.center)
          .frame(maxWidth: .infinity)
          .padding()
      } else {
        VStack {
          
          ProducSearchTabBarHeader(currentTab: $selectedTab, tabBarOptions: getGroupNames(vm.state.productGroups))
          
          TabView(selection: $selectedTab) {
            ScrollView {
              LazyVGrid(columns: layout) {
                ForEach(vm.state.productGroups, id: \.group.id) { groupWithProducts in
                  if(!groupWithProducts.products.isEmpty) {
                    Section {
                      ForEach(groupWithProducts.products, id: \.id) { product in
                        ProductListItem(product: product) {
                          vm.actual.addItem(product: product, amount: 1)
                          dismiss()
                        }
                        .foregroundColor(Color("textColor"))
                        .padding(10)
                      }
                    } header: {
                      HStack {
                        Color(UIColor.lightGray).frame(height: 1)
                        Text(groupWithProducts.group.name)
                        Color(UIColor.lightGray).frame(height: 1)
                      }
                    }
                  }
                }
                Spacer()
              }
              .padding()
            }
            .tag(0)
            
            ForEach(Array(vm.state.productGroups.enumerated()), id: \.element.group.id) { index, groupWithProducts in
              ScrollView {
                LazyVGrid(columns: layout, spacing: 0) {
                  ForEach(groupWithProducts.products, id: \.id) { product in
                    ProductListItem(product: product) {
                      vm.actual.addItem(product: product, amount: 1)
                      dismiss()
                    }
                    .foregroundColor(Color("textColor"))
                    .padding(10)
                  }
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
        .onChange(of: search, perform: vm.actual.filterProducts)
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Button(S.dialog.cancel()) {
              dismiss()
            }
          }
        }
      }
    }
  }
  
  private func getGroupNames(_ productGroups: Array<ProductGroupWithProducts>) -> Array<String> {
    var groupNames = productGroups.map { groupWithProducts in
      groupWithProducts.group.name
    }
    groupNames.insert(S.productSearch.allGroups(), at: 0)
    return groupNames
  }
}
