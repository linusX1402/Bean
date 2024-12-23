import SwiftUI

@main
struct BeanCounterApp: App {
    var body: some Scene {
        let viewModel = ViewModel()
        WindowGroup {
            ContentView(app: viewModel)
        }
    }
}

