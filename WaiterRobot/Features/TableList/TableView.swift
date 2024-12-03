import SharedUI
import SwiftUI

struct TableView: View {
    let text: String
    let hasOrders: Bool
    let backgroundColor: Color?
    let onClick: () -> Void

    @Environment(\.colorScheme)
    var colorScheme

    var body: some View {
        Button(action: onClick) {
            ZStack {
                Text(text)
                    .font(.title)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                if hasOrders {
                    VStack(alignment: .trailing) {
                        HStack {
                            Spacer()

                            Circle()
                                .foregroundColor(backgroundColor?.getContentColor(lightColorScheme: Color(.darkRed), darkColorScheme: Color(.lightRed)))
                                .frame(width: 12)
                        }

                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.trailing, 10)
                }
            }
        }
        .aspectRatio(1.0, contentMode: .fit)
        .background {
            if let backgroundColor {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(backgroundColor)
            } else {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.gray.opacity(0.3))
            }
        }
        .foregroundStyle(backgroundColor?.getContentColor(lightColorScheme: .black, darkColorScheme: .white) ?? .blackWhite)
    }
}

#Preview {
    VStack {
        TableView(text: "1", hasOrders: false, backgroundColor: .green) {}
            .frame(maxWidth: 100)

        TableView(text: "2", hasOrders: true, backgroundColor: nil) {}
            .frame(maxWidth: 100)
    }
}
