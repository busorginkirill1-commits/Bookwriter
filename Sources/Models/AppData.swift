import Foundation

struct Note: Identifiable, Codable {
    let id: UUID
    var text: String
    var date: Date

    init(id: UUID = UUID(), text: String) {
        self.id = id
        self.text = text
        self.date = Date()
    }
}

enum SkeletonType: String, Codable, CaseIterable {
    case chapter   = "Глава"
    case scene     = "Сцена"
    case character = "Персонаж"
    case location  = "Локация"

    var icon: String {
        switch self {
        case .chapter:   return "📑"
        case .scene:     return "🎬"
        case .character: return "👤"
        case .location:  return "📍"
        }
    }
}

struct SkeletonItem: Identifiable, Codable {
    let id: UUID
    var type: SkeletonType
    var title: String
    var date: Date

    init(id: UUID = UUID(), type: SkeletonType = .chapter, title: String) {
        self.id = id
        self.type = type
        self.title = title
        self.date = Date()
    }
}

struct Idea: Identifiable, Codable {
    let id: UUID
    var text: String
    var tag: String
    var date: Date

    init(id: UUID = UUID(), text: String, tag: String = "💡") {
        self.id = id
        self.text = text
        self.tag = tag
        self.date = Date()
    }
}

struct ChatMessage: Identifiable, Codable {
    let id: UUID
    var role: String   // "user" или "assistant"
    var text: String
    var date: Date

    init(id: UUID = UUID(), role: String, text: String) {
        self.id = id
        self.role = role
        self.text = text
        self.date = Date()
    }
}
