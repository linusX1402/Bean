import SwiftUI

@main
struct BeanCounterApp: App {
    @StateObject private var beanStorage = BeanStorage()
    
    var body: some Scene {
        var viewModel = ViewModel(beanStorage: beanStorage)
        WindowGroup {
            ContentView(app: viewModel) {
                Task {
                    await viewModel.saveData()
                }
            }
            .task {
                await viewModel.loadData()
            }
        }
    }
}
