import Foundation
import shared
import SwiftUI
import UIPilot
import WRCore

struct BillingScreen: View {
    @EnvironmentObject var navigator: UIPilot<Screen>

    @State private var showPayDialog: Bool = false
    @State private var showAbortConfirmation = false

    @StateObject private var viewModel: ObservableBillingViewModel
    private let table: shared.Table

    init(table: shared.Table) {
        self.table = table
        _viewModel = StateObject(wrappedValue: ObservableBillingViewModel(table: table))
    }

    var body: some View {
        let billItems = Array(viewModel.state.billItemsArray)

        content(billItems: billItems)
            .navigationTitle(localize.billing.title(value0: table.groupName, value1: table.number.description))
            .navigationBarTitleDisplayMode(.inline)
            .customBackNavigation(
                title: localize.dialog.cancel(),
                icon: nil
            ) {
                if viewModel.state.hasCustomSelection {
                    showAbortConfirmation = true
                } else {
                    viewModel.actual.abortBill()
                }
            }
            .confirmationDialog(
                localize.billing.notSent.title(),
                isPresented: $showAbortConfirmation,
                titleVisibility: .visible
            ) {
                Button(localize.dialog.closeAnyway(), role: .destructive) {
                    viewModel.actual.abortBill()
                }
            } message: {
                Text(localize.billing.notSent.desc())
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if !billItems.isEmpty {
                        Button {
                            viewModel.actual.selectAll()
                        } label: {
                            Image(systemName: "checkmark")
                        }
                    }

                    if !billItems.isEmpty {
                        Button {
                            viewModel.actual.unselectAll()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
            }
            // TODO: make only half screen when ios 15 is dropped
            .sheet(isPresented: $showPayDialog) {
                PayDialog(viewModel: viewModel)
            }
            .withViewModel(viewModel, navigator) { effect in
                switch onEnum(of: effect) {
                case .showPaymentSheet:
                    showPayDialog = true
                case .toast:
                    break // TODO: add "toast" support
                }

                return true
            }
    }

    @ViewBuilder
    private func content(billItems: [BillItem]) -> some View {
        VStack {
            List {
                if billItems.isEmpty {
                    Text(localize.billing.noOpenBill(value0: table.groupName, value1: table.number.description))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    Section {
                        ForEach(billItems, id: \.virtualId) { item in
                            BillListItem(
                                item: item,
                                addOne: {
                                    viewModel.actual.addItem(virtualId: item.virtualId, amount: 1)
                                },
                                addAll: {
                                    viewModel.actual.addItem(virtualId: item.virtualId, amount: item.ordered - item.selectedForBill)
                                },
                                removeOne: {
                                    viewModel.actual.addItem(virtualId: item.virtualId, amount: -1)
                                },
                                removeAll: {
                                    viewModel.actual.addItem(virtualId: item.virtualId, amount: -item.selectedForBill)
                                }
                            )
                        }
                    } header: {
                        HStack {
                            Text("Ordered")
                            Spacer()
                            Text("Selected")
                        }
                    }
                }
            }

            HStack {
                Text("\(localize.billing.total()):")
                Spacer()
                Text("\(viewModel.state.priceSum)")
            }
            .font(.title2)
            .padding()
            .overlay(alignment: .bottom) {
                Button {
                    viewModel.actual.paySelection(paymentSheetShown: false)
                } label: {
                    Image(systemName: "eurosign")
                        .font(.system(.title))
                        .padding()
                        .tint(.white)
                        .offset(x: -3)
                }
                .background(.blue)
                .mask(Circle())
                .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
                .disabled(viewModel.state.viewState != ViewState.Idle.shared || !viewModel.state.hasSelectedItems)
            }
        }
    }
}
