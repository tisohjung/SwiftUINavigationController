import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(
                    destination: Text("One Destination")
                        .navigationBarTitle("One Title", displayMode: NavigationBarItem.TitleDisplayMode.inline),
                    label: {
                        Text("One Label")
                    }
                )
                NavigationLink(
                    destination: ContentViewTwo(),
                    label: {
                        Text("Two: Pop example")
                    }
                )
                NavigationLink(
                    destination: ContentViewThree(),
                    label: {
                        Text("Three: Jump to Main>Two>Two-One")
                    })
            }
            .navigationBarHidden(true)
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(UINavigationController())
    }
}

// 1
struct ContentViewOne: View {
    var body: some View {
        NavigationView {
            NavigationLink(destination: ContentViewTwo()) {
                Text("1")
            }
        }
    }
}

// 2
struct ContentViewTwo: View {
    var body: some View {
        VStack {
            Text("2")
            Text("Try swipe back")
                .padding(.bottom, 10)
            Button("back") {
                Router.shared.pop(animated: true)
            }
            Button("MoreDetail") {
                Router.shared.push(view: ContentViewTwoOne(), animated: true)
            }
        }
        .navigationBarTitle("TWO", displayMode: NavigationBarItem.TitleDisplayMode.inline)
    }
}

// 2-1
struct ContentViewTwoOne: View {
    var body: some View {
        Text("2-1")
            .navigationBarTitle("TWO-ONE", displayMode: NavigationBarItem.TitleDisplayMode.large)
        Button("Pop to root") {
            Router.shared.popToRootViewController(animated: true)
        }
        Button("Pop to index 0") {
            Router.shared.popToIndex(index: 0, animated: true)
        }
    }
}

// 3
struct ContentViewThree: View {
    var body: some View {
        VStack {
            Text("Three Destination")
            Button("Jump to Main>Two") {
//                let deepLink = "route://main/two/twoOne"
//                Router.shared.parseDeepLink(url: deepLink)
                Router.shared.setViewControllers(stack: [
                    AnyView(ContentView()),
                    AnyView(ContentViewTwo())
                ])
            }
        }
        .navigationBarTitle("Three Title")
    }
}
