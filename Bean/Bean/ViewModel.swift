import Foundation
import Combine


struct Child: Codable, Identifiable {
    var id: Int
    var name: String
    var secondsPassedForNextBean: Int = 0
    var totalBeansToPay: Int = 0
    var isRunning: Bool = false
    var lastActionDate: Date?
    var hasBeenStoppedRecently: Bool = false
    var isAtWork: Bool = true
    var hasBeenGoneFor: Int = 0
    var stats: Stats = Stats()
    var payouts: [Payout] = []
}

struct Stats: Codable{
    var totalTimeWorked: Int = 0
    var totalTimeAway: Int = 0
    var totalBeansPayed: Int = 0
}

struct Payout: Codable, Identifiable {
    var id: UUID
    var payoutTime: Date
    var amount: Int
}

class ViewModel: ObservableObject {
    var id: Int = 0
    var timer = Timer()
    let userDefault = UserDefaults.standard
    
    @Published var settings: Settings = Settings()
    @Published var children: [Child] = []
    
    func updateChildren() {
        for var child in children {
            child.totalBeansToPay = settings.appSettings.startingFunds
            child.stats.totalBeansPayed = settings.appSettings.startingFunds
        }
    }
    
    init() {
        load()
        updateChildren()
        startGlobalTimer()
    }
    
    func save() {
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
        } else {
            print("Failed to get Data")
        }
    }

    
    func startGlobalTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.updateBeansToPay()
        })
    }
    
    func addChild(_ name: String) {
        children.append(Child(id: id, name: name, totalBeansToPay: settings.appSettings.startingFunds, stats: Stats(totalBeansPayed: settings.appSettings.startingFunds)))
        id += 1
        save()
    }

    func startAllTimers() {
        for i in children.indices {
            startTimer(i)
        }
    }
    
    func stopAllTimers() {
        for i in children.indices {
            stopTimer(i)
        }
    }
    
    func resetAllTimers() {
        stopAllTimers()
        for i in children.indices {
            children[i].isRunning = false
            resetTimer(i)
        }
    }
    
    func deleteAllChildren() {
        for child in children {
            removeChild(child)
        }
    }
    
    func removeChild(_ child: Child) {
        if let i = children.firstIndex(where: { $0.id == child.id }) {
            children.remove(at: i)
            save()
        }
    }
    
    func startTimer(_ i: Int) {
        children[i].isRunning = true
        children[i].isAtWork = true
        children[i].stats.totalTimeAway = children[i].hasBeenGoneFor;
        children[i].hasBeenGoneFor = 0
        children[i].lastActionDate = Date()
        save()
    }
    
    func stopTimer(_ i: Int) {
        children[i].isRunning = false
        if children[i].isAtWork {
            children[i].lastActionDate = Date()
        }
        if (children[i].secondsPassedForNextBean > 0) {
            children[i].hasBeenStoppedRecently = true
            save()
        }
        children[i].payouts.append(Payout (id: UUID() ,payoutTime: Date(), amount: children[i].totalBeansToPay))
        children[i].totalBeansToPay = 0
        children[i].isAtWork = false
        save()
    }
    
    func resetTimer(for child: Child) {
        if let i = children.firstIndex(where: { $0.id == child.id }) {
            resetTimer(i)
        }
    }
    
    func resetTimer(_ i: Int) {
        children[i].secondsPassedForNextBean = 0
        children[i].totalBeansToPay = settings.appSettings.startingFunds
        children[i].isRunning = false
        children[i].lastActionDate = nil
        children[i].hasBeenStoppedRecently = false
        children[i].isAtWork = true
        children[i].hasBeenGoneFor = 0
        children[i].stats = Stats(totalBeansPayed: settings.appSettings.startingFunds)
        children[i].payouts = []
    }
    
    func toggleTimer(_ child: Child) {
        if let i = children.firstIndex(where: { $0.id == child.id }) {
            if children[i].isRunning {
                stopTimer(i)
            } else {
                startTimer(i)
            }
        }
    }
    
    func updateBeansToPay() {
        for i in children.indices {
            if !children[i].isAtWork {
                children[i].hasBeenGoneFor += 1
                children[i].stats.totalTimeAway += 1
            }
            
            if children[i].isRunning {
                children[i].secondsPassedForNextBean += 1
                children[i].stats.totalTimeWorked += 1
                if var timeDiff = children[i].lastActionDate?.timeIntervalSinceNow {
                    timeDiff = round(timeDiff * -100) / 100
                    if (children[i].hasBeenStoppedRecently) {
                        timeDiff += Double(children[i].secondsPassedForNextBean)
                        children[i].secondsPassedForNextBean = 0
                    }
                    if ((timeDiff / Double(settings.appSettings.secondsPerTick * 60)) >= 1) {
                        children[i].totalBeansToPay += settings.appSettings.beansPerTick
                        children[i].stats.totalBeansPayed += settings.appSettings.beansPerTick
                        children[i].secondsPassedForNextBean = 0
                        children[i].lastActionDate = Date()
                        children[i].hasBeenStoppedRecently = false
                    }
                }
            }
        }
    }
}
