import Foundation
import SwiftUI

@MainActor
final class TodoStore: ObservableObject {
    @Published var items: [TodoItem] = [] {
        didSet { save() }
    }

    private let fileURL: URL
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init() {
        let fileManager = FileManager.default
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.fileURL = documents.appendingPathComponent("todos.json")

        self.encoder = JSONEncoder()
        self.encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        self.encoder.dateEncodingStrategy = .iso8601

        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601

        load()
    }

    func add(title: String) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        items.append(
            TodoItem(
                id: UUID(),
                title: trimmed,
                isDone: false,
                createdAt: Date(),
                completedAt: nil
            )
        )
    }

    func toggleDone(for item: TodoItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index].isDone.toggle()
        items[index].completedAt = items[index].isDone ? Date() : nil
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }

    func clear() {
        items.removeAll()
    }

    private func load() {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            items = []
            return
        }

        do {
            let data = try Data(contentsOf: fileURL)
            items = try decoder.decode([TodoItem].self, from: data)
        } catch {
            items = []
        }
    }

    private func save() {
        do {
            let data = try encoder.encode(items)
            try data.write(to: fileURL, options: [.atomic])
        } catch {
            // En una demo mínima no interrumpimos la UI por un error de guardado.
        }
    }
}
