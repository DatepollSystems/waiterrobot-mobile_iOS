import Combine
import shared
import SwiftUI
import WRCore

struct PayDialog: View {
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var viewModel: ObservableBillingViewModel

    @State private var moneyGiven: String = ""
    @State private var isInputInvalid = false

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text(localize.billing.total() + ":")
                        .font(.title2)
                    Spacer()
                    Text(viewModel.state.priceSum.description)
                        .font(.title2)
                }

                TextField(localize.billing.given(), text: $moneyGiven)
                    .font(.title)
                    .keyboardType(.numbersAndPunctuation)
                    .onChange(of: moneyGiven) { value in
                        viewModel.actual.moneyGiven(moneyGiven: value)
                    }
                    .frame(height: 48)
                    .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(isInputInvalid ? .red : .secondary, lineWidth: 2.0)
                    )

                HStack {
                    Text(localize.billing.change() + ":")
                        .font(.title2)
                    Spacer()

                    if let change = viewModel.state.change?.amount {
                        Text(change.description())
                            .font(.title2)
                    }
                }

                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(localize.dialog.cancel()) {
                        dismiss()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(localize.billing.pay()) {
                        viewModel.actual.paySelection(paymentSheetShown: true)
                        dismiss()
                    }
                }
            }
        }
    }
}
