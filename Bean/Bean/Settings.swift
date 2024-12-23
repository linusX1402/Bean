import Foundation

struct AppSettings: Codable {
    var secondsPerTick: Int = 5
    var beansPerTick: Int = 1
    var startingFunds: Int = 5
}

public class Settings {
    @Published var appSettings = AppSettings() {
        didSet {
            saveSettings()
        }
    }
    let userDefault = UserDefaults.standard
    
    func saveSettings() {
        do {
            let data = try JSONEncoder().encode(appSettings)
            userDefault.set(data, forKey: "settings")
        } catch {
            print("Error saving settings: \(error)")
        }
    }
    
    func loadSettings() {
        if let data = userDefault.data(forKey: "settings") {
            do {
                appSettings = try JSONDecoder().decode(AppSettings.self, from: data)
            } catch {
                print("Failed to decode settings: \(error)")
            }
        }
    }

    
    init() {
        loadSettings()
    }
}
