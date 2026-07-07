import Foundation

struct WreathEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var base: String
    var embellishments: String
    var season: String
    var notes: String
    var dateCreated: Date = Date()
}
