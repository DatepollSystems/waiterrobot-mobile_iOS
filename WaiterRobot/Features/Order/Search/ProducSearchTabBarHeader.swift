import SwiftUI

struct ProducSearchTabBarHeader: View {
    @Namespace var namespace
    @Binding var currentTab: Int
    var tabBarOptions: [String]

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(
                        Array(zip(tabBarOptions.indices, tabBarOptions)),
                        id: \.0
                    ) { index, name in

                        Button {
                            currentTab = index
                        } label: {
                            VStack {
                                Spacer()
                                Text(name)
                                    .padding(.horizontal)
                                if currentTab == index {
                                    Color.blue
                                        .frame(height: 2)
                                        .matchedGeometryEffect(
                                            id: "underline",
                                            in: namespace,
                                            properties: .frame
                                        )
                                } else {
                                    Color.clear.frame(height: 2)
                                }
                            }
                            .animation(.spring(), value: currentTab)
                        }
                        .buttonStyle(.plain)
                        .padding(0)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 30)
            .padding(.horizontal)
            .padding(.bottom, 7)
            Divider()
        }
    }
}

#Preview {
    ProducSearchTabBarHeader(
        currentTab: .constant(4), tabBarOptions: ["All", "Food", "Drinks", "more", "One more"]
    )
}
