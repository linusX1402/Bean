import SwiftUI
import UIKit

struct ContentView: View {
    @ObservedObject var app: ViewModel
    @State var currentTab = 0
    
    var body: some View {
        
            TabView(selection: $currentTab) {
                //Children
                VStack {
                    ChildrenView(app: app)
                }
                .tabItem {
                    Label("Children", systemImage: "person.2")
                }
                .tag(0)
                
                //Stats
                VStack {
                    StatsView(app: app)
                }
                .tabItem {
                    Label("Stats", systemImage: "chart.bar")
                }
                .tag(1)
                
                //Settings
                VStack {
                    SettingsView(app: app)
                }
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
            }
            .animation(.none, value: currentTab)
        }
    }


#Preview {
    let viewModel = ViewModel()
    let contentView = ContentView(app: viewModel)
        .environment(\.locale, .init(identifier: "de"))
    return contentView
}
