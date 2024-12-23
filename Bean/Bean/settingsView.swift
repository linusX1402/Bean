import SwiftUI

struct SettingsView: View {
    @ObservedObject var app: ViewModel
    @State private var selectedEmoji: String = "🫘" // Default emoji
    @State private var showEmojiPicker = false // To show emoji picker sheet

    var body: some View {
        List {
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.bottom, 10)
            
            // Beans per Tick
            HStack {
                Image(systemName: "")
                Text("Beans/Tick: \(app.settings.appSettings.beansPerTick)")
                Spacer()
                Stepper(value: $app.settings.appSettings.beansPerTick, in: 1...10) {}
            }
            .frame(width: .infinity)
            .padding(.horizontal, 10)
            
            // Tick duration
            HStack {
                Image(systemName: "")
                Text("Set ticks (min): \(app.settings.appSettings.secondsPerTick)")
                Spacer()
                Stepper(value: $app.settings.appSettings.secondsPerTick, in: 1...10) {}
            }
            .frame(width: .infinity)
            .padding(.horizontal, 10)
            
            // Starting funds
            HStack {
                Image(systemName: "")
                Text("Starting funds: \(app.settings.appSettings.startingFunds)")
                Spacer()
                Stepper(value: $app.settings.appSettings.startingFunds, in: 1...10) {}
            }
            .frame(width: .infinity)
            .padding(.horizontal, 10)
        }
        Spacer()
        Divider()
            .padding(.bottom, 15)
    }
}
#Preview {
    let viewModel = ViewModel()
    let settingsView = SettingsView(app: viewModel)
    return settingsView
}
