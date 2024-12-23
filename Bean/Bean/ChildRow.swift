import SwiftUI

struct ChildRow: View {
    var child: Child
    @ObservedObject var app: ViewModel
    
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
        Grid {
            GridRow {
                Text(child.name)
                    .padding(.trailing, 5)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Button(action: {app.toggleTimer(child)}){
                    
                    if (child.isRunning) {
                        Image(systemName: "stop")
                            .frame(width: 18, height: 18)
                            .padding(7)
                            .background(Color.red)
                            .cornerRadius(10)
                    } else {
                        Image(systemName: "play")
                            .frame(width: 18, height: 18)
                            .padding(7)
                            .background(Color.green)
                            .cornerRadius(10)
                        
                    }
                }
                .foregroundStyle(Color.white)
                if (child.isAtWork) {
                    Text("\(child.totalBeansToPay) 🫘")
                        .padding(.leading, 5)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                } else {
                    Text("\(formatTime(child.hasBeenGoneFor))")
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 5)
        .padding(.vertical, 3)
                    .background(!child.isAtWork ? Color.gray.opacity(0.2) : Color.clear)
                    .cornerRadius(10)
                    .overlay(
                        !child.isAtWork ? Color.white.opacity(0.3) : Color.clear
                    )
    }
}

#Preview {
    var viewModel = ViewModel()
    var contentView = ContentView(app: viewModel)
    return contentView
}
