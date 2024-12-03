import shared
import SwiftUI

struct Event: View {
    let event: shared.Event

    var body: some View {
        VStack(alignment: .leading) {
            Text(event.name)

            HStack {
                Text(event.city)
                    .font(.caption)
                    .foregroundColor(Color.gray)

                Spacer()

                if let date = event.startDate {
                    Text(date.description())
                        .font(.caption)
                        .foregroundColor(Color.gray)
                }
            }
        }
    }
}

#Preview {
    Event(
        event: shared.Event(
            id: 1,
            name: "My Event",
            startDate: nil,
            endDate: nil,
            city: "Graz",
            organisationId: 1,
            stripeSettings: shared.Event.StripeSettingsDisabled()
        )
    )
}
