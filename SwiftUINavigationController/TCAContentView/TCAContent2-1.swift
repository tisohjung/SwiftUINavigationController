import SwiftUI

struct TCAContentViewTwoOne: View {
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
