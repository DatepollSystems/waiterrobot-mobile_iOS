//
//  PullToRefresh.swift
//  WaiterRobot
//
//  Created by Fabian Schedler on 20.11.23.
//

import SwiftUI

struct PullToRefresh: View {
    let coordinateSpaceName: String
    let isRefreshing: Bool
    let onRefresh: () -> Void

    @State var needRefresh: Bool = false

    var body: some View {
        if isRefreshing {
            EmptyView()
        } else {
            GeometryReader { geo in
                if geo.frame(in: .named(coordinateSpaceName)).midY > 50 {
                    Spacer()
                        .onAppear {
                            needRefresh = true
                            print("NeedRefresh")
                        }
                } else if geo.frame(in: .named(coordinateSpaceName)).maxY < 10 {
                    Spacer()
                        .onAppear {
                            if needRefresh {
                                onRefresh()
                                needRefresh = false
                                print("RefreshStarted")
                            }
                        }
                }

                let pullProgress = max(0, min(50, geo.frame(in: .named(coordinateSpaceName)).midY)) / 50

                HStack {
                    Spacer()
                    ProgressView()
                        .opacity(pullProgress)
                        .controlSize(.large)
                        .tint(.gray)
                        .padding(.bottom, 50)
                    Spacer()
                }
            }.padding(.top, -50)
        }
    }
}
