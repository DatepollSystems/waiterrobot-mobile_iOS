import SwiftUI
import shared
import UIPilot

struct TableListScreen: View {
  @EnvironmentObject var navigator: UIPilot<Screen>
  
  @StateObject private var strongVM = ObservableViewModel(vm: koin.tableListVM())
  
  private var idiom: UIUserInterfaceIdiom {
    UIDevice.current.userInterfaceIdiom
  }
  
  private var columnSize: CGFloat {
    if idiom == .pad || idiom == .mac {
      return UIScreen.main.bounds.size.width / 6
    }
    
    return UIScreen.main.bounds.size.width / 4
  }
  
  private let layout = [
    GridItem(.adaptive(minimum: UIScreen.main.bounds.size.width / 4))
  ]
  
  var body: some View {
    unowned let vm = strongVM
    
    ScreenContainer(vm.state) {
      ScrollView {
        if vm.state.tables.isEmpty {
          Text(S.tableList.noTableFound())
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding()
        } else {
          LazyVGrid(columns: layout, spacing: 30) {
            ForEach(vm.state.tables, id: \.id) { table in
              Table(text: table.number.description, size: columnSize, onClick: {
                vm.actual.onTableClick(table: table)
              })
            }
          }
          .padding()
        }
      }
    }
    .navigationTitle(CommonApp.shared.settings.eventName)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button {
          vm.actual.openSettings()
        } label: {
          Image(systemName: "gear")
        }
      }
    }
    .refreshable {
      vm.actual.loadTables(forceUpdate: true)
    }
    .handleSideEffects(of: vm, navigator)
  }
}
