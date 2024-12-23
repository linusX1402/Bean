import SwiftUI

struct StatsView: View {
    @ObservedObject var app: ViewModel
    
    private func refresh() {
        
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Stats")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.bottom, 10)
                    .padding(.leading, 20)
                Spacer()
            }
            .padding(.top, 20)
            List {
                if (app.children.isEmpty) {
                    Text("No Children yet")
                } else {
                    ForEach($app.children, id: \.id) { $child in
                        StatsCard(child: $child)
                    }
                }
            }
            .listRowSeparator(.hidden)
            .refreshable {
                refresh()
            }
            Spacer()
            Divider()
                .padding(.bottom, 15)
        }
    }
}

#Preview {
    let viewModel = ViewModel()
    let statsView = StatsView(app: viewModel)
    return statsView
}
