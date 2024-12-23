import SwiftUI

@main
struct BeanCounterApp: App {
    var body: some Scene {
        var viewModel = ViewModel()
        WindowGroup {
            ContentView(app: viewModel)
        }
    }
}

