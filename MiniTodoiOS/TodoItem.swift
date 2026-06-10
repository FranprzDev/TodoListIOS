import Foundation

struct TodoItem: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var isDone: Bool
    let createdAt: Date
    var completedAt: Date?
}
