import SwiftUI
import Charts

struct StatsCard: View {
    @Binding var child: Child

    func formatTime(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let remainingSeconds = seconds % 60

        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, remainingSeconds)
        } else {
            return String(format: "%02d:%02d", minutes, remainingSeconds)
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(child.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding()
                Spacer()
            }
            Grid {
                HStack {
                    Text("Was away for: ")
                    Spacer()
                    Text("\(formatTime(child.stats.totalTimeAway))")
                }
                .padding(.vertical, 8)
                .padding(.horizontal)
                HStack {
                    Text("Has worked for: ")
                    Spacer()
                    Text("\(formatTime(child.stats.totalTimeWorked))")
                }
                .padding(.vertical, 8)
                .padding(.horizontal)
                HStack {
                    Text("TotalBeans: ")
                    Spacer()
                    Text("\(child.stats.totalBeansPayed)")
                }
                .padding(.vertical, 8)
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    var viewModel = ViewModel()
    var statsView = StatsView(app: viewModel)
    return statsView
}
