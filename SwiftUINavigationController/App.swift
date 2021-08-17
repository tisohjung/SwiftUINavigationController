//
//  SwiftUINavigationControllerApp.swift
//  SwiftUINavigationController
//
//  Created by minho on 2021/08/13.
//

import SwiftUI

@main
struct SwiftUINavigationControllerApp: App {
    var body: some Scene {
        WindowGroup {
            /// 1. Without TCA
//            ContentView()

            /// 2. TCA
            TCAContentView(
                store: TCAContentStore(
                    initialState: TCAContentState(),
                    reducer: tcaContentReducer,
                    environment: TCAContentEnvironment(router: Router.shared)
                )
            )
            .environmentObject(Router.shared.nvc)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    parseDeepLink()
                }
            }
        }
    }

    func parseDeepLink() {
        let deepLink = "route://main/two/twoOne"
        Router.shared.parseDeepLink(url: deepLink)
    }
}
