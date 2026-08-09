import Foundation

enum BookStatus: String, Codable, CaseIterable {
    case start  = "Начальная"
    case wip    = "В работе"
    case ready  = "Готова"

    var icon: String {
        switch self {
        case .start: return "📘"
        case .wip:   return "✍️"
        case .ready: return "✅"
        }
    }

    var color: String {
        switch self {
        case .start: return "blue"
        case .wip:   return "orange"
        case .ready: return "green"
        }
    }
}

struct Chapter: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var text: String

    init(id: UUID = UUID(), title: String = "Новая глава", text: String = "") {
        self.id = id
        self.title = title
        self.text = text
    }

    var wordCount: Int {
        text.split(separator: " ").count
    }
}

struct Book: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var status: BookStatus
    var chapters: [Chapter]
    var aiCalls: Int
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        title: String = "Новая книга",
        status: BookStatus = .start
    ) {
        self.id = id
        self.title = title
        self.status = status
        self.chapters = [Chapter()]
        self.aiCalls = 0
        self.createdAt = Date()
        self.updatedAt = Date()
    }

    var totalWords: Int {
        chapters.reduce(0) { $0 + $1.wordCount }
    }
}
