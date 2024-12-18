import Foundation

@MainActor
class BeanStorage: ObservableObject {
    @Published var children: [Child] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: true)
        .appendingPathComponent("children.json")
    }
    
    func load() async throws {
        let task = Task<[Child], Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }
            return try JSONDecoder().decode([Child].self, from: data)
        }
        let children = try await task.value
        self.children = children
    }
    
    func save(toSaveChildren: [Child]) async throws {
        let task = Task<Void, Error> {
            let data = try JSONEncoder().encode(toSaveChildren)
            let ourtfile = try Self.fileURL()
            try data.write(to: ourtfile)
        }
        _ = try await task.value
    }
}
