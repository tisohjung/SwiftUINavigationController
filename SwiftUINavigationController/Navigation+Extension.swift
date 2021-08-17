import SwiftUI

extension UINavigationController: ObservableObject {
    func push<Content: View>(view: Content, animated: Bool) {
        let hostedVC = UIHostingController(rootView: view)
        pushViewController(hostedVC, animated: animated)
    }

    func setViewControllers(stack: [AnyView]) {
        let host = UIHostingController(rootView: stack[0])
        viewControllers = [host]
        for (index, view) in stack.enumerated() where index != 0 {
            self.push(view: view, animated: false)
        }
        print(viewControllers)
    }
}

/// https://stackoverflow.com/questions/58234142/how-to-give-back-swipe-gesture-in-swiftui-the-same-behaviour-as-in-uikit-intera
struct NavigationView<Content: View>: UIViewControllerRepresentable {
    @EnvironmentObject var nvc: UINavigationController

    var stack: [AnyView] = []
    var prefersLargeTitle: Bool

    var content: () -> Content

    init(stack: [AnyView] = [], prefersLargeTitle: Bool = true, @ViewBuilder content: @escaping () -> Content) {
        self.stack = stack
        self.content = content
        self.prefersLargeTitle = prefersLargeTitle
    }

    func makeUIViewController(context: Context) -> UINavigationController {
        print("makeUIViewController")
        let nvc = UINavigationController()
        let host = UIHostingController(rootView: content().environmentObject(nvc))
        if nvc.viewControllers.count == 0 {
            nvc.viewControllers = [host]
        }
        stack.forEach({
            nvc.push(view: $0, animated: false)
        })
        nvc.setNavigationBarHidden(true, animated: false)
        nvc.isNavigationBarHidden = true
        nvc.navigationBar.prefersLargeTitles = prefersLargeTitle
        Router.shared.nvc = nvc
        return nvc
    }

    func push<Content: View>(vc: Content, animated: Bool) -> Self {
        let hostedVC = UIHostingController(rootView: vc)
        nvc.pushViewController(hostedVC, animated: animated)
        return self
    }

    func hideNavigationBar() -> Self { // some View {
        navigationBarTitle("")
            .navigationBarHidden(true)
        return self
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        print("updateUIViewController")
    }
}

struct NavigationLink<Destination: View, Label: View>: View {
    var destination: Destination
    var label: () -> Label

    public init(destination: Destination, @ViewBuilder label: @escaping () -> Label) {
        self.destination = destination
        self.label = label
    }

    /// If this crashes, make sure you wrapped the NavigationLink in a NavigationView
    var nvc: UINavigationController = Router.shared.nvc

    var body: some View {
        Button(action: {
            let rootView = self.destination.environmentObject(self.nvc)
            let hosted = UIHostingController(rootView: rootView)
            self.nvc.pushViewController(hosted, animated: true)
            self.nvc.isNavigationBarHidden = true
        }, label: label)
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        viewControllers.count > 1
    }
}

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<NavigationConfigurator>
    ) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(
        _ uiViewController: UIViewController,
        context: UIViewControllerRepresentableContext<NavigationConfigurator>
    ) {
        if let nav = uiViewController.navigationController {
            configure(nav)
        }
    }
}

//
///// Returns a Binding that is true if the value of `binding` equals `value`.
///// If the value of the resulting binding is set, the original binding is set to value/inEqualValue.
// public func isEqual<T: Equatable>(_ binding: Binding<T>, _ value: T, inEqualValue: T) -> Binding<Bool> {
//    Binding(
//        get: { binding.wrappedValue == value },
//        set: { newValue in binding.wrappedValue = newValue ? value : inEqualValue }
//    )
// }
