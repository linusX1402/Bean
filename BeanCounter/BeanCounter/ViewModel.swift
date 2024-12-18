import Foundation
import Combine

struct Child: Codable, Identifiable {
    var id: Int
    var name: String
    var secondsAlreadyPassed: Int = 0
    var totalBeansToPay: Int = 0
    var isRunning: Bool = false
    var startDate: Date?
    var hasBeenStoppedRecently: Bool = false
}

class ViewModel: ObservableObject {
    var id: Int = 0
    var timer = Timer()
    let userDefault = UserDefaults.standard
    
    
    @Published var settings: Settings = Settings()
    @Published var children: [Child] = []
    
    
    
    init() {
        load()
        viewDidLoad()
    }
    
    func persist() {
        do {
            let data = try JSONEncoder().encode(children)
            userDefault.set(data, forKey: "children")
            print("Persisted data")
        } catch {
            print("Failed to save Data: \(error)")
        }
    }

    func load() {
        if let data = userDefault.data(forKey: "children") {
            do {
                children = try JSONDecoder().decode([Child].self, from: data)
            } catch {
                print("Failed to decode Data: \(error)")
            }
            print(children)
        } else {
            print("Failed to get Data")
        }
    }

    
    func viewDidLoad() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.updateBeansToPay()
        })
    }
    
    func addChild(_ name: String) {
        children.append(Child(id: id, name: name))
        id += 1
        persist()
    }

    func startAllTimers() {
        for index in children.indices {
            startTimer(index)
        }
    }
    
    func stopAllTimers() {
        for index in children.indices {
            stopTimer(index)
        }
    }
    
    func resetAllTimers() {
        stopAllTimers()
        for child in children {
            resetTimer(for: child)
        }
    }
    
    func deleteAllChildren() {
        for child in children {
            removeChild(child)
        }
    }
    
    func removeChild(_ child: Child) {
        if let index = children.firstIndex(where: { $0.id == child.id }) {
            children.remove(at: index)
            persist()
        }
    }
    
    func startTimer(_ index: Int) {
        children[index].isRunning = true
        children[index].startDate = Date()
        persist()
    }
    
    func stopTimer(_ index: Int) {
        children[index].isRunning = false
        if (children[index].secondsAlreadyPassed > 0) {
            children[index].hasBeenStoppedRecently = true
            persist()
        }
    }
    
    func resetTimer(for child: Child) {
        if let index = children.firstIndex(where: { $0.id == child.id }) {
            stopTimer(index)
            children[index].startDate = nil
            children[index].totalBeansToPay = 0
            persist()
        }
    }
    
    func toggleTimer(_ child: Child) {
        if let index = children.firstIndex(where: { $0.id == child.id }) {
            if children[index].isRunning {
                stopTimer(index)
            } else {
                startTimer(index)
            }
        }
    }
    
    var tmpCounter = 0
    
    func updateBeansToPay() {
        for index in children.indices {
            if children[index].isRunning {
                if (!children[index].hasBeenStoppedRecently) {
                    children[index].secondsAlreadyPassed += 1
                }
                tmpCounter += 1
                if let timeDifference = children[index].startDate?.timeIntervalSinceNow {
                    var intTimeDifference = Int(timeDifference * -1)
                    
                    if (children[index].hasBeenStoppedRecently) {
                        intTimeDifference += children[index].secondsAlreadyPassed
                        children[index].secondsAlreadyPassed = 0
                    }
                    if ((intTimeDifference / (settings.secondsPerTick)) >= 1) {
                        children[index].totalBeansToPay += settings.beansPerTick
                        children[index].secondsAlreadyPassed = 0
                        children[index].startDate = Date()
                        tmpCounter = 0
                        children[index].hasBeenStoppedRecently = false
                    }
                }
            }
        }
    }
}
