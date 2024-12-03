import SwiftUI

private struct SharedUIExample: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("h1")
            Text("h2")
            Text("h3")
            Text("h4")
            Text("h5")
            Text("h6")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

#Preview {
    SharedUIExample()
}
