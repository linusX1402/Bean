import Foundation

enum Languages {
    case en
    case de
}

public class Settings {
    var language: Languages = .en
    var darkMode: Bool = false
    var secondsPerTick: Int = 5
    var beansPerTick: Int = 1
}
