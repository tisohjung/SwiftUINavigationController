import Combine
import SwiftUI

protocol RouterProtocol {
    static var shared: Router { get }
    var nvc: UINavigationController { get }
    func pop(animated: Bool)
    func popToRootViewController(animated: Bool)
    func popToIndex(index: Int, animated: Bool)
    func push<Content: View>(view: Content, animated: Bool)
    func setViewControllers(stack: [AnyView])
}

class Router: RouterProtocol {
    static var shared: Router = Router()
    var nvc: UINavigationController = UINavigationController()

    private init() {}

    func pop(animated: Bool) {
        nvc.popViewController(animated: animated)
    }

    func popToRootViewController(animated: Bool) {
        nvc.popToRootViewController(animated: animated)
    }

    func popToIndex(index: Int, animated: Bool) {
        if index < nvc.viewControllers.count {
            nvc.popToViewController(nvc.viewControllers[index], animated: animated)
        }
    }

    func push<Content: View>(view: Content, animated: Bool) {
        nvc.push(view: view, animated: animated)
    }

    func setViewControllers(stack: [AnyView]) {
        nvc.setViewControllers(stack: stack)
    }
}

enum RoutePath: String {
    case main
    case one
    case two
    case twoOne
    case three
    case unknown

    init(fromString: String) {
        self = RoutePath(rawValue: fromString) ?? .unknown
    }
}

extension RouterProtocol {
    func justParseDeepLink(url: String) -> AnyPublisher<Void, Never> {
        Just(()).map({ parseDeepLink(url: url) }).eraseToAnyPublisher()
    }
    func parseDeepLink(url: String) {
        let url = url.replacingOccurrences(of: "route://", with: "")
        let arrayRoute = url.split(separator: "?")[0].split(separator: "/")
        print(arrayRoute)
        for routeString in arrayRoute {
            let routePath = RoutePath(fromString: String(routeString))
            switch routePath {
            case .main:
                setViewControllers(stack: [AnyView(
                    TCAContentView(
                        store: TCAContentStore(
                            initialState: TCAContentState(),
                            reducer: tcaContentReducer,
                            environment: TCAContentEnvironment(router: Router.shared)
                        )
                    )
                    .environmentObject(UINavigationController())
                )])
                break
            case .one:
                push(view: TCAContentViewOne(), animated: false)
            case .two:
                push(view: TCAContentTwoView(
                    store: TCAContentTwoStore(
                        initialState: TCAContentTwoState(),
                        reducer: tcaContentTwoReducer,
                        environment: TCAContentTwoEnvironment(
                            router: Router.shared
                        )
                    )
                ),
                animated: false)
            case .twoOne:
                push(view: TCAContentViewTwoOne(), animated: false)
            case .three:
                push(view: TCAContentViewThree(), animated: false)
            case .unknown:
                break
            }
        }
    }

    // Main
    func loadMain() -> AnyPublisher<Void, Never> {
        Just(())
            .map {
                setViewControllers(stack: [AnyView(
                    TCAContentView(
                        store: TCAContentStore(
                            initialState: TCAContentState(),
                            reducer: tcaContentReducer,
                            environment: TCAContentEnvironment(router: Router.shared)
                        )
                    )
                    .environmentObject(UINavigationController())
                )])
            }
            .eraseToAnyPublisher()
    }
    func moveToOne() -> AnyPublisher<Void, Never> {
        Just(())
            .map({ _ in push(view: TCAContentViewOne(), animated: true) })
            .eraseToAnyPublisher()
    }

    func moveToTwo() -> AnyPublisher<Void, Never> {
        Just(())
            .map({ _ in
                push(view: TCAContentTwoView(store: TCAContentTwoStore(
                    initialState: TCAContentTwoState(),
                    reducer: tcaContentTwoReducer,
                    environment: TCAContentTwoEnvironment(router: Router.shared)
                )),
                animated: true)
            })
            .eraseToAnyPublisher()
    }

    func moveToThree() -> AnyPublisher<Void, Never> {
        Just(())
            .map({ _ in push(view: TCAContentViewThree(), animated: true) })
            .eraseToAnyPublisher()
    }

    // Two
    func moveToTwoOne() -> AnyPublisher<Void, Never> {
        Just(())
            .map({ _ in push(view: TCAContentViewTwoOne(), animated: true) })
            .eraseToAnyPublisher()
    }

    func justPop(animated: Bool) -> AnyPublisher<Void, Never> {
        Just(())
            .map({ _ in pop(animated: animated) })
            .eraseToAnyPublisher()
    }
    func justPush<Content: View>(view: Content, animated: Bool) -> AnyPublisher<Void, Never> {
        Just(())
            .map({ _ in push(view: view, animated: animated)})
            .eraseToAnyPublisher()
    }
}
