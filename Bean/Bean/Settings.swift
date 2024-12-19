import Foundation

enum Languages {
    case en
    case de
}
enum IconStyle {
    case light
    case dark
}

public class Settings {
    @Published var language: Languages = .en
    @Published var darkMode: Bool = false
    @Published var iconStye: IconStyle = .light
    @Published var secondsPerTick: Int = 5
    @Published var beansPerTick: Int = 1
}
