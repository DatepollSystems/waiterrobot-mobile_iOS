import SwiftUI

struct SettingsItem<Action: View>: View {
    let icon: String
    let title: String
    let subtitle: String
    @ViewBuilder let action: Action?
    let onClick: () -> Void

    var body: some View {
        Button {
            onClick()
        } label: {
            HStack {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 25)
                    .padding(.trailing)

                VStack(alignment: .leading) {
                    Text(title)
                        .foregroundColor(.primary)

                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                if let action {
                    Spacer()
                    action
                }
            }
        }
        .padding([.bottom, .top], 1)
    }
}

extension SettingsItem where Action == EmptyView {
    init(icon: String, title: String, subtitle: String, onClick: @escaping () -> Void) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        action = nil
        self.onClick = onClick
    }
}

#Preview {
    List {
        SettingsItem(
            icon: "rectangle.portrait.and.arrow.right",
            title: "Logout",
            subtitle: "Logout from this organisation",
            onClick: {}
        )
        SettingsItem(
            icon: "person.3",
            title: "Switch event",
            subtitle: "My Organisation / The Event",
            onClick: {}
        )
        SettingsItem(
            icon: "dollarsign.arrow.circlepath",
            title: "Toggle",
            subtitle: "Some toggle able",
            action: {
                Toggle(isOn: .constant(true)) {}.labelsHidden()
            },
            onClick: {}
        )
    }
}
