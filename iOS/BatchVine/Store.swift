import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var entries: [WreathEntry] = []
    @Published var isPro: Bool = false

    static let freeLimit = 23

    private let fileURL: URL = {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("batchvine_entries.json")
    }()

    init() {
        load()
        if entries.isEmpty {
            seed()
        }
    }

    func seed() {
        entries = [
        WreathEntry(name: "Winter Pine Wreath", base: "Grapevine", embellishments: "Pinecones, red berries", season: "Winter", notes: "Front door, 18in"),
        WreathEntry(name: "Spring Eucalyptus", base: "Straw form", embellishments: "Dried eucalyptus, ribbon", season: "Spring", notes: "Sold at market"),
        WreathEntry(name: "Autumn Wheat Wreath", base: "Wire frame", embellishments: "Wheat stalks, sunflowers", season: "Fall", notes: "Craft fair sample")
        ]
        save()
    }

    var canAddMore: Bool {
        isPro || entries.count < Store.freeLimit
    }

    func add(name: String, base: String, embellishments: String, season: String, notes: String) {
        guard canAddMore else { return }
        let entry = WreathEntry(name: name, base: base, embellishments: embellishments, season: season, notes: notes)
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: WreathEntry) {
        if let idx = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[idx] = entry
            save()
        }
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: WreathEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        if let decoded = try? JSONDecoder().decode([WreathEntry].self, from: data) {
            entries = decoded
        }
    }

    func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
