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
    var beanStorage: BeanStorage
    
    @Published var settings: Settings = Settings()
    @Published var children: [Child] = []
    
    
    
    init(beanStorage: BeanStorage) {
        self.beanStorage = beanStorage
        viewDidLoad()
    }
    
    
    func saveData() async {
        do {
            try await beanStorage.save(toSaveChildren: children)
        } catch {
            print("Failed to persist data: \(error)")
        }
    }
    
    func loadData() async {
        do {
            try await beanStorage.load()
            children = await beanStorage.children
        } catch {
            print("Failed to load data: \(error)")
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
        }
    }
    
    func startTimer(_ index: Int) {
        children[index].isRunning = true
        children[index].startDate = Date()
    }
    
    func stopTimer(_ index: Int) {
        children[index].isRunning = false
        if (children[index].secondsAlreadyPassed > 0) {
            children[index].hasBeenStoppedRecently = true
        }
    }
    
    func resetTimer(for child: Child) {
        if let index = children.firstIndex(where: { $0.id == child.id }) {
            stopTimer(index)
            children[index].startDate = nil
            children[index].totalBeansToPay = 0
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
