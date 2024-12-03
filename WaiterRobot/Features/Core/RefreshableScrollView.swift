//
//  RefreshableScrollView.swift
//  WaiterRobot
//
//  Created by Fabian Schedler on 20.11.23.
//

import shared
import SwiftUI

struct RefreshableScrollView<Content: View>: View {
    private let isRefreshing: Bool
    private let onRefresh: () -> Void
    private let content: () -> Content

    init(
        isRefreshing: Bool,
        onRefresh: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.isRefreshing = isRefreshing
        self.onRefresh = onRefresh
        self.content = content
    }

    init(
        resource: Resource<some Any>,
        onRefresh: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(for: onEnum(of: resource), onRefresh: onRefresh, content: content)
    }

    init(
        for resource: Skie.org_datepollsystems_waiterrobot__shared.Resource.__Sealed<some Any>,
        onRefresh: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        if case .loading = resource {
            self.init(isRefreshing: true, onRefresh: onRefresh, content: content)
        } else {
            self.init(isRefreshing: false, onRefresh: onRefresh, content: content)
        }
    }

    var body: some View {
        ScrollView {
            PullToRefresh(
                coordinateSpaceName: "PullToRefresh",
                isRefreshing: isRefreshing,
                onRefresh: onRefresh
            )
            if isRefreshing {
                ProgressView()
                    .controlSize(.large)
                    .tint(.gray)
            }
            content()
        }.coordinateSpace(name: "PullToRefresh")
    }
}

#Preview {
    RefreshableScrollView(
        isRefreshing: true,
        onRefresh: {}
    ) {
        Text("Refreshing")
    }
}

#Preview {
    RefreshableScrollView(
        isRefreshing: false,
        onRefresh: {}
    ) {
        Text("Pull to refresh")
    }
}
