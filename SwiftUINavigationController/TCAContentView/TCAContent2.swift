import SwiftUI

import ComposableArchitecture

// MARK: State

public struct TCAContentTwoState: Equatable {
    public static func == (lhs: TCAContentTwoState, rhs: TCAContentTwoState) -> Bool {
        return true
    }
    public init() {}
}

// MARK: Action

enum TCAContentTwoAction: Equatable {
    case onLoad
    case pop
    case moveToTwoOne
}

// MARK: Reducer

typealias TCAContentTwoReducer = Reducer<TCAContentTwoState, TCAContentTwoAction, TCAContentTwoEnvironment>

let tcaContentTwoReducer = TCAContentTwoReducer()

extension TCAContentTwoReducer {
    static var live: TCAContentTwoReducer = TCAContentTwoReducer()
    init() {
        self = Self.combine(
            .init { state, action, environment in
                switch action {
                case .onLoad:
                    return .none
                case .pop:
                    return environment.router.justPop(animated: true).fireAndForget()
                case .moveToTwoOne:
                    return environment.router.justPush(view: TCAContentViewTwoOne(), animated: true).fireAndForget()
                }
            }
        )
        .debug()
    }
}

// MARK: Environment

struct TCAContentTwoEnvironment {
    let router: RouterProtocol
}

typealias TCAContentTwoStore = Store<TCAContentTwoState, TCAContentTwoAction>
typealias TCAContentTwoViewStore = ViewStore<TCAContentTwoState, TCAContentTwoAction>

// MARK: TCAContentTwoView

struct TCAContentTwoView: View {

    @ObservedObject private var viewStore: TCAContentTwoViewStore
    private let store: TCAContentTwoStore

    lazy var stack: [AnyView] = [
        AnyView(TCAContentTwoView(
                    store: TCAContentTwoStore(
                        initialState: TCAContentTwoState(),
                        reducer: TCAContentTwoReducer(),
                        environment: TCAContentTwoEnvironment(router: Router.shared)
                    ))),
        AnyView(TCAContentViewTwoOne())]

    init(store: TCAContentTwoStore,
         stack: [AnyView] = []) {
        self.viewStore = ViewStore(store)
        self.store = store

        self.stack = stack
    }

    var body: some View {
        VStack() {
            Text("2")
            Text("Try swipe back")
                .padding(.bottom, 10)
            Button("back") {
                viewStore.send(.pop)
            }
            Button("MoreDetail") {
                viewStore.send(.moveToTwoOne)
            }
        }
        .navigationBarTitle("TWO", displayMode: NavigationBarItem.TitleDisplayMode.inline)
    }
}
