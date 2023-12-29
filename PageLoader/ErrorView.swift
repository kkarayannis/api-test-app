import SwiftUI

struct ErrorView: View {
    let reloadCallback: () -> Void
    
    // TODO: user better keys for localization
    var body: some View {
        VStack (alignment: .center) {
            Text("Something went wrong.")
                .font(.title)
            Text("Please check your connection and try again.")
            Button("Try again") {
                reloadCallback()
            }
            .padding()
        }
    }
}

#Preview {
    ErrorView() {}
}
