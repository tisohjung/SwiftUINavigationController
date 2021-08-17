import SwiftUI

struct TCAContentViewThree: View {
    var body: some View {
        VStack {
            Text("Three Destination")
            Button("Jump to Main>Two") {
                Router.shared.nvc.setViewControllers(
                    stack: [
                        AnyView(
                            TCAContentView(
                                store: TCAContentStore(
                                    initialState: TCAContentState(),
                                    reducer: tcaContentReducer,
                                    environment: TCAContentEnvironment(router: Router.shared)
                                )
                            )
                            .environmentObject(Router.shared.nvc)
                        ), AnyView(
                            TCAContentTwoView(
                                store: TCAContentTwoStore(
                                    initialState: TCAContentTwoState(),
                                    reducer: tcaContentTwoReducer,
                                    environment: TCAContentTwoEnvironment(router: Router.shared)
                                )
                            )
                        )
                    ]
                )
            }
        }
        .navigationBarTitle("Three Title")
    }
}
