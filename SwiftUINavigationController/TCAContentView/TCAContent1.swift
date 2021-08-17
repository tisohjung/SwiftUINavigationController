import SwiftUI

// MARK: - TCAContentViewOne

struct TCAContentViewOne: View {
    var body: some View {
        Button("Pop", action: {
            Router.shared.pop(animated: true)
        })
    }
}
