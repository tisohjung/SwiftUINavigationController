import SwiftUI

import Combine
import ComposableArchitecture

// MARK: - State

public struct TCAContentState: Equatable {
    public static func == (lhs: TCAContentState, rhs: TCAContentState) -> Bool {
        return true
    }
    public init() {}
}

// MARK: Action

enum TCAContentAction: Equatable {
    case onLoad
    case pop
    case moveToOne
    case moveToTwo
    case moveToTwoOne
    case moveToThree
    case deepLink(String)
}

// MARK: Reducer

typealias TCAContentReducer = Reducer<TCAContentState, TCAContentAction, TCAContentEnvironment>

let tcaContentReducer = TCAContentReducer()
extension TCAContentReducer {
    init() {
        self = Self.combine(
            .init { _, action, environment in
                switch action {
                case .onLoad:
                    return .none
                case .pop:
                    return .none
                case .moveToOne:
                    return .none
                case .moveToTwo:
                    return .none
                case .moveToTwoOne:
                    return .none
                case .moveToThree:
                    return .none
                case .deepLink(_):
                    return .none
                }
            },
            routerReducer
        )
        .debug()
    }
}

// MARK: Environment

struct TCAContentEnvironment {
    let router: RouterProtocol
}

typealias TCAContentStore = Store<TCAContentState, TCAContentAction>
typealias TCAContentViewStore = ViewStore<TCAContentState, TCAContentAction>

// MARK: TCAContentView

struct TCAContentView: View {
    @ObservedObject private var viewStore: TCAContentViewStore
    private let store: TCAContentStore

    init(store: TCAContentStore) {
        self.viewStore = ViewStore(store)
        self.store = store
    }

    var body: some View {
        NavigationView() {
            AnyView(List() {
                Button("One Destination", action: {
                    viewStore.send(.moveToOne)
                })
                Button("Two: Pop example", action: {
                    viewStore.send(.moveToTwo)
                })
                Button("Three: Jump to Main>Two>Two-One", action: {
                    viewStore.send(.moveToThree)
                })
//                NavigationLink(
//                    destination: Text("One Destination")
//                        .navigationBarTitle("One Title")
//                        .navigationBarHidden(true),
//                    label: {
//                        Text("One Label")
//                    }
//                )
//                NavigationLink(
//                    destination: TCAContentTwoView(store: TCAContentTwoStore(
//                        initialState: TCAContentTwoState(),
//                        reducer: tcaContentTwoReducer,
//                        environment: TCAContentTwoEnvironment(router: Router.shared)
//                    )),
//                    label: {
//                        Text("Two: Pop example")
//                    }
//                )
//                NavigationLink(
//                    destination: TCAContentViewThree(),
//                    label: {
//                        Text("Three: Jump to Main>Two>Two-One")
//                    }
//                )
                Button("Deeplink route://main/two/twoOne") {
                    viewStore.send(.deepLink("route://main/two/twoOne"))
                }
            }
            .navigationBarHidden(true)
            )
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct TCAContentView_Previews: PreviewProvider {
    static var previews: some View {
        TCAContentView(
            store: TCAContentStore(
                initialState: TCAContentState(),
                reducer: TCAContentReducer(),
                environment: TCAContentEnvironment(router: Router.shared)
            )
        )
        .environmentObject(UINavigationController())
    }
}
