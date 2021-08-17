import SwiftUI

import ComposableArchitecture

typealias RouterReducer = Reducer<
    TCAContentState,
    TCAContentAction,
    TCAContentEnvironment
>

let routerReducer: RouterReducer = .init { _, action, environment in
    switch action {
    case .moveToOne:
        return environment.router.justPush(view: TCAContentViewOne(), animated: true).fireAndForget()
    case .moveToTwo:
        return environment.router.moveToTwo().fireAndForget()
    case .pop:
        return environment.router.justPop(animated: true).fireAndForget()
    case .moveToTwoOne:
        return environment.router.moveToTwoOne().fireAndForget()
    case .moveToThree:
        return environment.router.moveToThree().fireAndForget()
    case .deepLink(let route):
        return environment.router.justParseDeepLink(url: route).fireAndForget()
    default:
        return .none
    }
}
